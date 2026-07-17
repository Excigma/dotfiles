{ ... }:
{
  imports = [
    ../../profiles/nixos/base.nix
    # TODO: Install NixOS on this machine
    # ./hardware.nix
  ];

  networking.hostName = "akl-opi-zero-2w";
  nixpkgs.hostPlatform = "aarch64-linux";
}
