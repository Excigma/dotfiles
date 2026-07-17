{ ... }:
{
  imports = [
    ../../profiles/nixos/daily-driver.nix
    ./hardware.nix
  ];

  networking.hostName = "latitude-nixos";
}
