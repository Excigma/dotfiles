{ pkgs, ... }:
let
  latitudeEq = import ../../modules/nixos/audio/latitude-eq.nix;
  speakerPreamp = latitudeEq.preamp * 0.354813389234;
  limiterBypass = false;
in
{
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "effects";
      runtimeInputs = [
        pkgs.pipewire
        pkgs.wireplumber
        pkgs.jq
      ];
      text = builtins.readFile ../../modules/nixos/audio/effects-toggle.sh;
    })
  ];

  systemd.user.services.effects-routing = {
    description = "Keep application audio on the selected effects route";
    wantedBy = [ "default.target" ];
    after = [
      "pipewire.service"
      "wireplumber.service"
    ];
    requires = [ "pipewire.service" ];
    serviceConfig = {
      ExecStart = "${
        pkgs.writeShellApplication {
          name = "effects-watch";
          runtimeInputs = [
            pkgs.pipewire
            pkgs.jq
          ];
          text = builtins.readFile ../../modules/nixos/audio/effects-watch.sh;
        }
      }/bin/effects-watch";
      Restart = "always";
      RestartSec = 1;
    };
  };

  services.pipewire = {
    extraLv2Packages = [ pkgs.bankstown-lv2 ];
    extraConfig.pipewire = {
      "20-bankstown" = {
        # Preamp -> gentle Bankstown bass enhancement -> IR/dry mix -> limiter.
        # Keep the existing sink ID and config filename for routing compatibility.
        "context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            # never take the whole audio server down if the plugin is missing
            flags = [ "nofail" ];
            args = {
              "node.description" = "Bankstown + IR";
              "media.name" = "Bankstown + IR";
              "filter.graph" = {
                nodes = [
                  # Reduce both channels equally before the IR and dry branches.
                  {
                    name = "eq_preamp_l";
                    type = "builtin";
                    label = "linear";
                    control = {
                      "Mult" = speakerPreamp;
                      "Add" = 0.0;
                    };
                  }
                  {
                    name = "eq_preamp_r";
                    type = "builtin";
                    label = "linear";
                    control = {
                      "Mult" = speakerPreamp;
                      "Add" = 0.0;
                    };
                  }
                  {
                    name = "bankstown";
                    # Add bass harmonics that small speakers can reproduce.
                    type = "lv2";
                    plugin = "https://chadmed.au/bankstown";
                    control = {
                      bypass = 0;
                      # Overall strength of the bass enhancement.
                      amt = 1.5;
                      # Bass range used to generate harmonics.
                      floor = 60;
                      ceil = 260;
                      final_hp = 170;
                      # Drive for the second and third harmonics.
                      sat_second = 2.0;
                      sat_third = 1.35;
                      # Favor second harmonics for a lower, fuller bass emphasis.
                      blend = 0.25;
                    };
                  }
                  # Split the signal into IR and dry (no IR) branches.
                  {
                    name = "eq_copy_l";
                    type = "builtin";
                    label = "copy";
                  }
                  {
                    name = "eq_copy_r";
                    type = "builtin";
                    label = "copy";
                  }
                  # Match the linear-phase IR's 4096-sample delay (85.3 ms).
                  {
                    name = "dry_delay_l";
                    type = "builtin";
                    label = "delay";
                    config."max-delay" = 0.1;
                    control = {
                      "Delay (s)" = 4096.0 / 48000.0;
                      "Feedback" = 0.0;
                      "Feedforward" = 0.0;
                    };
                  }
                  {
                    name = "dry_delay_r";
                    type = "builtin";
                    label = "delay";
                    config."max-delay" = 0.1;
                    control = {
                      "Delay (s)" = 4096.0 / 48000.0;
                      "Feedback" = 0.0;
                      "Feedforward" = 0.0;
                    };
                  }
                  # Combine the IR branch at 1.0 gain with the dry branch at 0.6.
                  {
                    name = "ir_mix_l";
                    type = "builtin";
                    label = "mixer";
                    control = {
                      "Gain 1" = 0.9;
                      "Gain 2" = 0.7;
                    };
                  }
                  {
                    name = "ir_mix_r";
                    type = "builtin";
                    label = "mixer";
                    control = {
                      "Gain 1" = 0.9;
                      "Gain 2" = 0.7;
                    };
                  }
                  {
                    name = "ir_preamp_l";
                    type = "builtin";
                    label = "linear";
                    # Reduce the IR input to 0.6 amplitude (about -4.4 dB).
                    control = {
                      "Mult" = 0.6;
                      "Add" = 0.0;
                    };
                  }
                  # Apply the tonal response stored in the impulse-response WAV.
                  {
                    name = "ir_l";
                    type = "builtin";
                    label = "convolver";
                    config = {
                      filename = "${../../modules/nixos/audio/impulse.wav}";
                      channel = 0;
                      gain = 1.0;
                    };
                  }
                  {
                    name = "ir_preamp_r";
                    type = "builtin";
                    label = "linear";
                    # Reduce the IR input to 0.6 amplitude (about -4.4 dB).
                    control = {
                      "Mult" = 0.6;
                      "Add" = 0.0;
                    };
                  }
                  {
                    name = "ir_r";
                    # Use the WAV's right channel for the right speaker.
                    type = "builtin";
                    label = "convolver";
                    config = {
                      filename = "${../../modules/nixos/audio/impulse.wav}";
                      channel = 1;
                      gain = 1.0;
                    };
                  }
                ]
                ++ pkgs.lib.optionals (!limiterBypass) [
                  {
                    # Catch peaks above -1.5 dB with 5 ms lookahead.
                    # Limit both channels together to preserve stereo balance.
                    # Absolute path also keeps the plugin in the system closure.
                    name = "limiter";
                    type = "ladspa";
                    plugin = "${pkgs.ladspaPlugins}/lib/ladspa/fast_lookahead_limiter_1913.so";
                    label = "fastLookaheadLimiter";
                    control = {
                      "Input gain (dB)" = 0.0;
                      "Limit (dB)" = -1.5;
                      "Release time (s)" = 0.1;
                    };
                  }
                ];
                # Connections define how audio flows between the stages.
                links = [
                  {
                    output = "eq_preamp_l:Out";
                    input = "bankstown:in_l";
                  }
                  {
                    output = "eq_preamp_r:Out";
                    input = "bankstown:in_r";
                  }
                  {
                    output = "bankstown:out_l";
                    input = "eq_copy_l:In";
                  }
                  {
                    output = "bankstown:out_r";
                    input = "eq_copy_r:In";
                  }
                  {
                    output = "eq_copy_l:Out";
                    input = "ir_preamp_l:In";
                  }
                  {
                    output = "eq_copy_r:Out";
                    input = "ir_preamp_r:In";
                  }
                  {
                    output = "eq_copy_l:Out";
                    input = "dry_delay_l:In";
                  }
                  {
                    output = "eq_copy_r:Out";
                    input = "dry_delay_r:In";
                  }
                  {
                    output = "ir_preamp_l:Out";
                    input = "ir_l:In";
                  }
                  {
                    output = "ir_preamp_r:Out";
                    input = "ir_r:In";
                  }
                  {
                    output = "ir_l:Out";
                    input = "ir_mix_l:In 1";
                  }
                  {
                    output = "ir_r:Out";
                    input = "ir_mix_r:In 1";
                  }
                  {
                    output = "dry_delay_l:Out";
                    input = "ir_mix_l:In 2";
                  }
                  {
                    output = "dry_delay_r:Out";
                    input = "ir_mix_r:In 2";
                  }
                ]
                ++ pkgs.lib.optionals (!limiterBypass) [
                  {
                    output = "ir_mix_l:Out";
                    input = "limiter:Input 1";
                  }
                  {
                    output = "ir_mix_r:Out";
                    input = "limiter:Input 2";
                  }
                ];
                inputs = [
                  "eq_preamp_l:In"
                  "eq_preamp_r:In"
                ];
                outputs =
                  if limiterBypass then
                    [
                      "ir_mix_l:Out"
                      "ir_mix_r:Out"
                    ]
                  else
                    [
                      "limiter:Output 1"
                      "limiter:Output 2"
                    ];
              };
              "capture.props" = {
                "node.name" = "bankstown_sink";
                "media.class" = "Audio/Sink";
                "audio.position" = [
                  "FL"
                  "FR"
                ];
              };
              "playback.props" = {
                "node.passive" = true;
                "node.target" = "alsa_output.pci-0000_00_1f.3.analog-stereo";
                "target.object" = "alsa_output.pci-0000_00_1f.3.analog-stereo";
                "stream.dont-remix" = true;
                "audio.position" = [
                  "FL"
                  "FR"
                ];
              };
            };
          }
        ];
      };
      "21-effects-off" = {
        "context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            flags = [ "nofail" ];
            args = {
              "node.description" = "Effects Off (-8 dB)";
              "media.name" = "Effects Off (-8 dB)";
              "filter.graph" = {
                nodes = [
                  {
                    name = "off_gain_l";
                    type = "builtin";
                    label = "linear";
                    control = {
                      "Mult" = 0.4;
                      "Add" = 0.0;
                    };
                  }
                  {
                    name = "off_gain_r";
                    type = "builtin";
                    label = "linear";
                    control = {
                      "Mult" = 0.4;
                      "Add" = 0.0;
                    };
                  }
                ];
                inputs = [
                  "off_gain_l:In"
                  "off_gain_r:In"
                ];
                outputs = [
                  "off_gain_l:Out"
                  "off_gain_r:Out"
                ];
              };
              "capture.props" = {
                "node.name" = "effects_off_sink";
                "media.class" = "Audio/Sink";
                "audio.position" = [
                  "FL"
                  "FR"
                ];
              };
              "playback.props" = {
                "node.passive" = true;
                "node.target" = "alsa_output.pci-0000_00_1f.3.analog-stereo";
                "target.object" = "alsa_output.pci-0000_00_1f.3.analog-stereo";
                "stream.dont-remix" = true;
                "audio.position" = [
                  "FL"
                  "FR"
                ];
              };
            };
          }
        ];
      };
    };

    wireplumber.extraConfig = {
      "60-effects-routing" = {
        "wireplumber.settings"."node.stream.restore-target" = false;
      };
    };
  };
}
