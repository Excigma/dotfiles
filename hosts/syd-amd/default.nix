{ ... }:
{
  imports = [
    ../../profiles/nixos/server.nix
    # TODO: Install NixOS on this machine
    # ./hardware.nix
  ];

  networking.hostName = "syd-amd";
  nixpkgs.hostPlatform = "x86_64-linux";
}
