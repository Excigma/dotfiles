{ pkgs, lib, self, ... }:
let
  inherit (lib) getExe;
in
{
  # Shared CLI package list and config come from base.nix.
  imports = [ ./base.nix ];

  # Termux home dir, not /home/excigma
  home.homeDirectory = lib.mkForce "/data/data/com.termux/files/home";

  # zsh.nix sets EDITOR/VISUAL to vscode; keep GUI tools out of the CLI profile.
  programs.zsh.sessionVariables = {
    VISUAL = lib.mkForce (getExe pkgs.neovim);
    EDITOR = lib.mkForce (getExe pkgs.neovim);
  };

  # Resolve <nixpkgs> to the pinned flake input.
  nix.nixPath = [ "nixpkgs=${self.inputs.nixpkgs}" ];
}
