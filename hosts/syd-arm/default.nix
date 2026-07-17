{ ... }:
{
  imports = [
    ../../profiles/nixos/server.nix
    # TODO: Install NixOS on this machine
    # ./hardware.nix
  ];

  networking.hostName = "syd-arm";
  nixpkgs.hostPlatform = "aarch64-linux";
}
