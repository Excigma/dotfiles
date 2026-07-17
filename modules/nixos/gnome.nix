{ pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.gnome-browser-connector.enable = true;
    udev.packages = with pkgs; [
      gnome-settings-daemon
    ];
  };

  environment.gnome.excludePackages = with pkgs; [
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

  # Custom keybinding scripts and other gnome configs linked
  # TODO: Doesn't appear to work
  systemd.tmpfiles.rules = [
    "L+ /etc/xdg/monitors.xml - - - - /home/excigma/.config/monitors.xml"
  ];
}
