{ ... }:
{
  imports = [
    ../../profiles/nixos/desktop.nix
    # TODO: Install NixOS on this machine
    # ./hardware.nix
  ];

  networking.hostName = "akl-fujitsu-nixos";
  nixpkgs.hostPlatform = "x86_64-linux";
}
