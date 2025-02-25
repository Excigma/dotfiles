# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, user, ... }: {
  imports = let inherit (builtins) filter attrNames readDir;
  in map (file: "${./.}/${file}") (filter (x: x != "default.nix") (attrNames (readDir ./.)));

  # Bootloader.
  boot.loader = {
    timeout = 0;
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "latitude-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  services.fwupd.enable = true;
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;
  services.tailscale.extraSetFlags = [ "--advertise-exit-node" "--operator=excigma" ];
  services.tailscale.extraUpFlags = [ "--ssh" ];

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
      # packages = with pkgs; [
      # ];
    };
  };

  security.sudo.extraRules = [{
    users = [ user ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
    }];
  }];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver # your Open GL, Vulkan and VAAPI drivers
      vpl-gpu-rt # for newer GPUs on NixOS >24.05 or unstable
      # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
      # intel-media-sdk   # for older GPUs
    ];
  };

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  programs = {
    firefox = { enable = true; };
    dconf.enable = true;
    nix-ld.enable = true;
    virt-manager.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };

  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    enableGlobalCompInit = true;
    enableLsColors = true;
    syntaxHighlighting.enable = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };

  environment.pathsToLink = [ "/share/zsh" ];
  environment.shells = with pkgs; [ zsh ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    brave
    xournalpp
    rnote
    arch-install-scripts
    adw-gtk3
    blender
    bitwarden
    smartmontools
    cloudflared
    flameshot
    eyedropper
    eza
    fastfetch
    foomatic-db-ppds-withNonfreeDb
    foomatic-db-engine
    gutenprint
    gh
    gimp
    gnirehtet
    gnome-power-manager
    gnome-tweaks
    htop
    helvum
    intel-gpu-tools
    intel-undervolt
    ghostty
    playerctl
    libreoffice-fresh
    libsmbios
    lmstudio
    localsend
    nixd
    nixfmt-classic
    miniserve
    mosh
    prismlauncher
    vlc
    nano
    openfortivpn
    rustup
    putty
    resources
    rsync
    scrcpy
    stress
    thermald
    (tela-circle-icon-theme.override { colorVariants = [ "blue" ]; })
    tlrc
    ventoy
    xpra
    yt-dlp

    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol

    vscode

    zsh
    zsh-autosuggestions
    zsh-autocomplete
    zsh-completions
    zsh-history
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zoxide

    go-10mb-video

    ffmpeg
    fdk-aac-encoder
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
