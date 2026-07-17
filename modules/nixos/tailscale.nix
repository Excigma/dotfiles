{ user, ... }:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraSetFlags = [
      "--advertise-exit-node"
      "--operator=${user}"
    ];
    extraUpFlags = [ "--ssh" ];
  };
}
