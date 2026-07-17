{ pkgs, user, ... }:
{
  imports = [
    ./base.nix
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/fonts.nix
  ];

  services = {
    printing.enable = true;
    fwupd.enable = true;
  };

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    # browsers & terminal
    chromium
    ghostty
    gnome-terminal

    # clipboard & notifications
    wl-clipboard
    libnotify

    # gnome utilities
    eyedropper
    gnome-power-manager
    gnome-tweaks
    nautilus-python
    resources

    # theming
    adw-gtk3
    (tela-circle-icon-theme.override { colorVariants = [ "blue" ]; })

    # audio
    easyeffects
    pavucontrol
    playerctl
    spotify

    # video/media
    ffmpeg
    vlc

    # development
    alsa-tools
    vscode.fhs
    linux-wifi-hotspot
    miniserve
    rclone
  ];

  home-manager.users.${user} = {
    imports = [ ../home-manager/desktop.nix ];
  };
}
