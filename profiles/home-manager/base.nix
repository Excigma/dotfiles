{ self, ... }:
{
  imports = [
    ./minimal.nix
    ../../modules/home-manager/zsh.nix
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
