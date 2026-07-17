{
  pkgs,
  user,
  self,
  ...
}:
{
  imports = [
    ./desktop.nix
    ../../modules/nixos/virtualisation.nix
  ]
  ++ (if builtins.pathExists ../../secrets/default.nix then [ ../../secrets ] else [ ]);

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # 27031..27036
    dedicatedServer.openFirewall = true; # 27015
    localNetworkGameTransfers.openFirewall = true; # 27040
  };

  users = {
    users.${user}.extraGroups = [
      "kvm"
      "adbusers"
      "dialout"
      "plugdev"
    ];
    groups.plugdev = { };
  };

  services.udev = {
    packages = with pkgs; [
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

  environment.etc."distrobox/distrobox.conf" = {
    enable = true;
    source = "${self}/etc/distrobox/distrobox.conf";
  };

  environment.systemPackages = with pkgs; [
    # development tools
    nixd
    nixfmt
    nodejs
    pnpm
    python3
    rustup

    # android tools
    android-tools
    better-adb-sync
    gnirehtet
    scrcpy

    # productivity & documents
    libreoffice-fresh
    rnote
    xournalpp

    # media creators - video & graphics
    blender
    fdk-aac-encoder
    gimp
    gradia
    go-10mb-video
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    inkscape
    obs-studio
    iriunwebcam

    # gaming
    prismlauncher

    # system
    arch-install-scripts
  ];

  home-manager.users.${user} = {
    imports = [ ../home-manager/daily-driver.nix ];
  };
}
