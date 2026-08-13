{ self, pkgs, ... }:
{
  imports = [
    ./minimal.nix
    ../../modules/home-manager/zsh.nix
  ];

  # Shared CLI package list, used on every host (laptop, servers, and Termux alike).
  home.packages = with pkgs; [
    eza
    bat
    fd
    ripgrep
    fastfetch
    fzf
    zsh-powerlevel10k
    nix-tree
    nixfmt
    neovim
  ];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      settings.user = {
        name = "Excigma";
        email = "git+excigma@breaks.systems";
      };
    };
  };

  home.file = {
    ".config" = {
      source = "${self}/.config";
      recursive = true;
    };
  };
}
