{ ... }:
{
  imports = [
    ../../profiles/nixos/daily-driver.nix
    ./audio.nix
    ./hardware.nix
  ];

  networking.hostName = "latitude-nixos";
}
