{ user, ... }:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraSetFlags = [
      "--operator=${user}"
    ];
    extraUpFlags = [ "--ssh" ];
  };
}
