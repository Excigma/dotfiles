{
  self,
  pkgs,
  lib,
  user,
  ...
}:
let
  inherit (builtins)
    filter
    attrNames
    readDir
    listToAttrs
    ;
  inherit (lib) flatten;
in
{
  imports = map (file: "${./.}/${file}") (
    filter (x: x != "default.nix" && builtins.match ".*.nix" x != null) (attrNames (readDir ./.))
  );

  boot = {
    tmp = {
      useTmpfs = true;
      tmpfsSize = "85%";
    };
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    extraModprobeConfig = ''
      options snd-hda-intel patch=hda-jack-retask.fw
    '';
  };

  zramSwap = {
    enable = false;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  networking = {
    hostName = "latitude-nixos";
    networkmanager.enable = true;
    # wireless.enable = true; # wpa_supplicant
    # stateful firewall is enabled by default
    # firewall = {
    # 	# allowedTCPPorts = [ 25565 ];
    # 	# allowedUDPPorts = [ 25565 ];
    #   # enable = false; # disable firewall
    # };
    firewall.enable = false;
  };

  services = {
    avahi.enable = true; # mDNS
    fstrim.enable = true;
    printing.enable = true; # CUPS
    fwupd.enable = true; # firmware updates
    thermald.enable = true;
    cloudflared.enable = true;
    # foldingathome = {
    #   enable = true;
    # };
    # openssh.enable = true;
    gvfs.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "suspend";
      HandlePowerKey = "suspend";
      HandlePowerKeyLongPress = "suspend";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      raopOpenFirewall = true;

      extraConfig.pipewire = {
        "10-airplay" = {
          "context.modules" = [
            {
              name = "libpipewire-module-raop-discover";

              # increase the buffer size if you get dropouts/glitches
              # args = {
              #   "raop.latency.ms" = 500;
              # };
            }
          ];
        };
        "92-latency-fix" = {
          # The Intel CPU is slightly underpowered, so there is popping with default settings.
          # We need to do the opposite of "low latency" as suggested by the NixOS wiki to avoid popping under load.
          # Fixed quantum size to avoid popping when EasyEffects is running and a new channel is added.
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [ 48000 ];
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 1024;
            "default.clock.max-quantum" = 1024;
          };
        };
      };

      # From: https://github.com/TLATER/dotfiles/blob/19d3fecfff648c0fa7371f2cec14363a0da2e44f/nixos-config/default.nix#L166C1-L216C9
      # Disable the HFP bluetooth profile, because I always use external
      # microphones anyway. It sucks and sometimes devices end up caught
      # in it even if I have another microphone.
      wireplumber.extraConfig = {
        "50-bluez" = {
          "monitor.bluez.rules" = [
            {
              matches = [ { "device.name" = "~bluez_card.*"; } ];
              actions = {
                update-props = {
                  "bluez5.auto-connect" = [
                    "a2dp_sink"
                    "a2dp_source"
                  ];
                  "bluez5.hw-volume" = [
                    "a2dp_sink"
                    "a2dp_source"
                  ];
                };
              };
            }
          ];
          "monitor.bluez.properties" = {
            "bluez5.roles" = [
              "a2dp_sink"
              "a2dp_source"
              "bap_sink"
              "bap_source"
            ];

            "bluez5.codecs" = [
              "ldac"
              "aptx"
              "aptx_ll_duplex"
              "aptx_ll"
              "aptx_hd"
              "opus_05_pro"
              "opus_05_71"
              "opus_05_51"
              "opus_05"
              "opus_05_duplex"
              "aac"
              "sbc_xq"
              "sbc"
            ];

            "bluez5.hfphsp-backend" = "none";
            # "bluez5.enable-hw-volume" = "false";
          };
        };
      };
    };
    udev = {
      packages = with pkgs; [
        gnome-settings-daemon
        openocd
        platformio-core
      ];
      extraRules = ''
        SUBSYSTEM!="usb_device", ACTION!="add", GOTO="rpi2_end"
        # Raspberry Pi Pico
        ATTR{idVendor}=="2e8a", ATTRS{idProduct}=="0003", MODE="0666", GROUP="plugdev"

        LABEL="rpi2_end"

        SUBSYSTEM!="usb_device", ACTION!="add", GOTO="leavers_end"
        # ECSE Leaver's Dinner Invites
        ATTR{idVendor}=="2e8a", ATTRS{idProduct}=="000a", MODE="0666", GROUP="plugdev"

        LABEL="leavers_end"
      '';
    };
    tailscale = {
      enable = true;
      openFirewall = true;
      extraSetFlags = [
        "--advertise-exit-node"
        "--operator=${user}"
      ];
      extraUpFlags = [ "--ssh" ];
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome = {
      gnome-browser-connector.enable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    groups.libvirtd.members = [ user ];
    defaultUserShell = pkgs.zsh;
    groups = {
      plugdev = { };
    };
    users.${user} = {
      isNormalUser = true;
      description = user;
      extraGroups = [
        "kvm"
        "adbusers"
        "docker"
        "networkmanager"
        "wheel"
        "input"
        "video"
        "libvirtd"
        "dialout"
        "plugdev"
      ];
      # packages = with pkgs; [];
    };
  };

  security = {
    rtkit.enable = true; # gui privilege escalation
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        vhostUserPackages = with pkgs; [
          virtiofsd
        ];
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    docker = {
      enable = true;
    };
    spiceUSBRedirection.enable = true;
  };

  hardware = {
    firmware = [
      (pkgs.writeTextDir "/lib/firmware/hda-jack-retask.fw" (builtins.readFile "${self}/etc/firmware/hda-jack-retask.fw"))
    ];
    sensor.iio.enable = true;
    logitech.wireless = {
      enableGraphical = true;
      enable = true;
    };
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-ocl
        intel-compute-runtime
        intel-media-driver # opengl, vulkan, vaapi
        vpl-gpu-rt
      ];
    };
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
  };

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
      vista-fonts
      corefonts
      inter
      dotcolon-fonts
      newcomputermodern
      iosevka-bin
    ];
  };

  programs = {
    command-not-found.enable = false;
    dconf.enable = true;
    nix-ld.enable = true;
    localsend = {
      enable = true;
      openFirewall = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # 27031..27036
      dedicatedServer.openFirewall = true; # 27015
      localNetworkGameTransfers.openFirewall = true; # 27040
    };
    virt-manager.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    enableCompletion = true;
    autosuggestions = {
      enable = true;
      async = true;
    };
    shellAliases = {
      ls = null;
    };
    enableGlobalCompInit = true;
    syntaxHighlighting.enable = true;
    shellInit = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
       source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi'';
    promptInit = ''
      # To customize prompt, run `p10k configure` or edit /etc/powerlevel10k/.p10k.zsh.
      [[ ! -f /etc/powerlevel10k/.p10k.zsh ]] || source /etc/powerlevel10k/.p10k.zsh

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
  };

  systemd.services = {
    NetworkManager-wait-online.enable = false;
  };

  systemd.tmpfiles.rules = [
    "L+ /etc/xdg/monitors.xml - - - - /home/${user}/.config/monitors.xml"
  ];

  environment = {
    gnome.excludePackages = with pkgs; [
      geary
      gnome-backgrounds
      gnome-console
      gnome-contacts
      gnome-logs
      gnome-maps
      gnome-music
      gnome-text-editor
      gnome-tour
      gnome-weather
      totem # videos
      yelp # help
    ];
    etc = listToAttrs (
      map
        (name: {
          inherit name;
          value = {
            enable = true;
            source = "${self}/etc/${name}";
          };
        })
        [
          # etc imports
          "distrobox/distrobox.conf"
          "powerlevel10k/.p10k.zsh"
          # "xdg/mimeapps.list"
        ]
    );
    systemPackages =
      with pkgs;
      flatten [
        # shell & terminal
        [
          eza
          fastfetch
          htop
          jq
          libnotify
          mosh
          nano
          rsync
          stress
          tlrc
          wget
          wl-clipboard
          zoxide
          zsh-completions
        ]

        # development
        [
          gh
          nh
          nixd
          nixfmt-rfc-style
          nodejs
          pnpm
          python3
          rustup
          vscode.fhs
        ]

        # android
        [
          android-tools
          better-adb-sync
          gnirehtet
          scrcpy
        ]

        # browsers
        [
          chromium
        ]

        # communication
        [
          discord
          # signal-desktop
          slack
          # telegram-desktop
        ]

        # productivity & documents
        [
          # folio
          libreoffice-fresh
          rnote
          xournalpp
          # zotero
        ]

        # media - audio
        [
          alsa-tools
          easyeffects
          pavucontrol
          playerctl
          spotify
        ]

        # media - video & recording
        [
          fdk-aac-encoder
          ffmpeg
          gradia
          go-10mb-video
          gpu-screen-recorder
          gpu-screen-recorder-gtk
          # kdePackages.kdenlive
          obs-studio
          vlc
          # snapx
        ]

        # media - graphics & design
        [
          blender
          gimp
          inkscape
          # pstoedit
        ]

        # virtualization
        [
          # spice
          # spice-gtk
          # spice-protocol
          # virt-manager
          # virt-viewer
          # virtiofsd
        ]

        # networking & remote access
        [
          # cloudflared
          # deskflow
          iriunwebcam
          linux-wifi-hotspot
          miniserve
          # putty
          rclone
          # xpra
        ]

        # hardware utilities
        [
          intel-gpu-tools
          intel-undervolt
          libsmbios
          logitech-udev-rules
          pciutils
          qmassa
          smartmontools
          solaar
          usbutils
        ]

        # gnome & desktop
        [
          eyedropper
          ghostty
          gnome-power-manager
          gnome-terminal
          gnome-tweaks
          # crosspipe
          nautilus-python
          resources
        ]

        # theming
        [
          adw-gtk3
          (tela-circle-icon-theme.override { colorVariants = [ "blue" ]; })
        ]

        # printing
        [
          # foomatic-db-engine
          # foomatic-db-ppds-withNonfreeDb
          # gutenprint
        ]

        # system & misc
        [
          arch-install-scripts
          # fahclient
          # mamba-cpp
          prismlauncher
        ]
      ];
  };

  # Some programs need SUID wrappers, which means they won't work without the options
  # programs.mtr.enable = true;

  time.timeZone = "Pacific/Auckland";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_NZ.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_ADDRESS = "en_NZ.UTF-8";
      LC_IDENTIFICATION = "en_NZ.UTF-8";
      LC_MEASUREMENT = "en_NZ.UTF-8";
      LC_MONETARY = "en_NZ.UTF-8";
      LC_NAME = "en_NZ.UTF-8";
      LC_NUMERIC = "en_NZ.UTF-8";
      LC_PAPER = "en_NZ.UTF-8";
      LC_TELEPHONE = "en_NZ.UTF-8";
      LC_TIME = "en_NZ.UTF-8";
    };
  };

  # It‘s perfectly fine and recommended to leave this value
  # at the release version of the first install of this system.
  system.stateVersion = "24.11"; # Did you read the comment?
}
