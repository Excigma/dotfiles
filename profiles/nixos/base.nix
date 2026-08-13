{
  pkgs,
  user,
  self,
  ...
}:
{
  imports = [
    ./minimal.nix
    ../../modules/nixos/tailscale.nix
  ];

  boot = {
    tmp = {
      useTmpfs = true;
      tmpfsSize = "85%";
    };
  };

  networking.networkmanager.enable = true;
  users.users.${user}.extraGroups = [ "networkmanager" ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  programs.nix-ld.enable = true;

  programs.zsh = {
    enableBashCompletion = true;
    enableCompletion = true;
    autosuggestions = {
      enable = true;
      async = true;
    };
    shellAliases = {
      ls = null;
    };
    # zsh-autocomplete runs its own compinit; keep /etc/zshrc from running one.
    enableGlobalCompInit = false;
    # fast-syntax-highlighting (loaded from home-manager) replaces the stock one.
    syntaxHighlighting.enable = false;
    shellInit = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
       source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi'';
    promptInit = ''
      # To customize prompt, run `p10k configure` or edit /etc/powerlevel10k/.p10k.zsh.
      [[ ! -f /etc/powerlevel10k/.p10k.zsh ]] || source /etc/powerlevel10k/.p10k.zsh

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
  };

  environment.systemPackages = with pkgs; [
    eza
    nh
    fastfetch
    htop
    jq
    mosh
    rsync
    stress
    tlrc
    wget
    zoxide
    zsh-completions
  ];

  environment.etc = {
    "powerlevel10k/.p10k.zsh" = {
      enable = true;
      source = "${self}/etc/powerlevel10k/.p10k.zsh";
    };
  };

  home-manager.users.${user} = {
    imports = [ ../home-manager/base.nix ];
  };
}
