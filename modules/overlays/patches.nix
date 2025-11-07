{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      tailscale = prev.tailscale.overrideAttrs (old: {
        checkFlags = builtins.map (
          flag:
          if prev.lib.hasPrefix "-skip=" flag then flag + "|^TestGetList$|^TestIgnoreLocallyBoundPorts$|^TestPoller$" else flag
        ) old.checkFlags;
      });

      marble-shell-theme = prev.marble-shell-theme.overrideAttrs (prevAttrs: {
        patches = [
          ./patches/marble-hide-notification-message.patch
          ./patches/marble-disable-taskbar-icon-background.patch
          ./patches/marble-fix-quick-settings-padding.patch
          ./patches/marble-increase-workspace-border.patch
        ]
        ++ (prevAttrs.patches or [ ]);
      });

      nautilus-python = prev.nautilus-python.overrideAttrs (prevAttrs: {
        patches = [ ./patches/nautilus-python-single-path.patch ] ++ (prevAttrs.patches or [ ]);
      });

      power-profiles-daemon = prev.power-profiles-daemon.overrideAttrs (prevAttrs: {
        # Disable tests, as they take a long time to run.
        mesonFlags = (prevAttrs.mesonFlags or [ ]) ++ [ "-Dtests=false" ];
        patches = [ ./patches/ppd-use-cool-platform-profile.patch ] ++ (prevAttrs.patches or [ ]);
      });

      rnote = prev.rnote.overrideAttrs (prevAttrs: {
        patches = [
          ./patches/rnote-enlarge-selection-bounds.patch
          ./patches/rnote-move-pen-picker-to-top.patch
          ./patches/rnote-tap-to-select.patch
        ]
        ++ (prevAttrs.patches or [ ]);
      });

      sound-theme-freedesktop = prev.sound-theme-freedesktop.overrideAttrs (prevAttrs: {
        postInstall = (prevAttrs.postInstall or "") + "rm -f $out/share/sounds/freedesktop/stereo/screen-capture.oga";
      });

      easyeffects = prev.easyeffects.overrideAttrs (prevAttrs: {
        version = "test";
        patches = [ ./patches/easyeffects-use-bankstown.patch ] ++ (prevAttrs.patches or [ ]);
        preFixup =
          let
            lv2Plugins = [
              prev.bankstown-lv2
              prev.calf # compressor exciter, bass enhancer and others
              prev.lsp-plugins # delay, limiter, multiband compressor
              prev.mda_lv2 # loudness
              prev.zam-plugins # maximizer
            ];

            ladspaPlugins = [
              prev.deepfilternet # deep noise remover
              prev.rubberband # pitch shifting
            ];
          in
          ''
            gappsWrapperArgs+=(
              --set LV2_PATH "${prev.lib.makeSearchPath "lib/lv2" lv2Plugins}"
              --set LADSPA_PATH "${prev.lib.makeSearchPath "lib/ladspa" ladspaPlugins}"
            )
          '';
      });
    })
  ];
}
