{ self, pkgs, lib, user, ... }:
let
  inherit (builtins) filter attrNames readDir listToAttrs;
  inherit (lib) flatten;
in {
  imports = map (file: "${./.}/${file}") (filter (x: x != "default.nix") (attrNames (readDir ./.)));

  boot.loader = {
    timeout = 0;
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
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
  };

  services = {
    printing.enable = true; # CUPS
    fwupd.enable = true; # firmware updates
    thermald.enable = true;
    # openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;
    };
    udev.packages = with pkgs; [ gnome-settings-daemon ];
    tailscale = {
      enable = true;
      openFirewall = true;
      extraSetFlags = [ "--advertise-exit-node" "--operator=${user}" ];
      extraUpFlags = [ "--ssh" ];
    };
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    gnome = { gnome-browser-connector.enable = true; };
  };

  # Enable automatic rotation.
  hardware.sensor.iio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    groups.libvirtd.members = [ user ];
    defaultUserShell = pkgs.zsh;
    users.${user} = {
      isNormalUser = true;
      description = user;
      extraGroups = [ "networkmanager" "wheel" "input" "video" "libvirtd" ];
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
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    podman = {
      enable = true;
      dockerCompat = true;
    };
    spiceUSBRedirection.enable = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver # opengl, vulkan, vaapi
      vpl-gpu-rt
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  programs = {
    command-not-found.enable = false;
    dconf.enable = true;
    nix-ld.enable = true;
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
    shellAliases = { ls = null; };
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

  environment = {
    etc = listToAttrs (map (name: {
      inherit name;
      value = {
        enable = true;
        source = "${self}/etc/${name}";
      };
    }) [ # etc imports
      "distrobox/distrobox.conf"
      "powerlevel10k/.p10k.zsh"
      "xdg/mimeapps.list"
    ]);
    systemPackages = with pkgs;
      flatten [
        # cli
        [
          android-tools
          wget
          arch-install-scripts
          eza
          fastfetch
          distrobox
          gh
          htop
          scrcpy
          nano
          rsync
          stress
          mosh
          tlrc
          intel-gpu-tools
          intel-undervolt
          usbutils
          pciutils
        ]

        # text & notes
        [
          xournalpp
          rnote
          libreoffice-fresh
        ]

        # qemu
        [
          virt-manager
          virt-viewer
          spice
          spice-gtk
          spice-protocol
        ]

        # zsh
        [
          zsh-completions
          zsh-history
          zoxide
        ]

        # dev
        [
          arduino-ide
          rustup
          lmstudio
          nixd
          nix-output-monitor
          nix-index
          nixfmt-classic
          vscode
        ]

        # network
        [
          chromium
          cloudflared
          gnirehtet
          iriunwebcam
          localsend
          miniserve
          openfortivpn
          putty
          xpra
        ]

        # social
        [
          discord
          slack
          signal-desktop
        ]

        # media
        [
          blender
          playerctl
          vlc
          yt-dlp
          go-10mb-video
          ffmpeg
          fdk-aac-encoder
          flameshot
          gimp
        ]

        # printing
        [
          foomatic-db-ppds-withNonfreeDb
          foomatic-db-engine
          gutenprint
        ]

        # theming
        [
          adw-gtk3
          (tela-circle-icon-theme.override { colorVariants = [ "blue" ]; })
        ]

        # other
        [
          bitwarden
          eyedropper
          gnome-power-manager
          gnome-tweaks
          ghostty
          helvum
          resources

          libsmbios
          smartmontools
          ventoy

          prismlauncher
        ]
      ];
  };

  # Some programs need SUID wrappers, which means they won't work without the options
  # programs.mtr.enable = true;

  time.timeZone = "Pacific/Auckland";
  i18n = {
    defaultLocale = "en_US.UTF-8";
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
