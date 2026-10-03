{
  self,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./minimal.nix
    ../../modules/home-manager/zsh.nix
  ];

  home.sessionVariables.NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
  home.sessionPath = [ "${config.home.homeDirectory}/.npm-global/bin" ];

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
    bash = {
      enable = true;
      initExtra = ''
        if [[ ":$PATH:" != *":$HOME/.npm-global/bin:"* ]]; then
          export PATH="$HOME/.npm-global/bin:$PATH"
        fi
        if [[ -z "''${NPM_CONFIG_PREFIX-}" ]]; then
          export NPM_CONFIG_PREFIX="$HOME/.npm-global"
        fi
      '';
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
