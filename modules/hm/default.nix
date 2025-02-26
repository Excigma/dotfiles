{ user, self, ... }: {
  imports = let inherit (builtins) filter attrNames readDir;
  in map (file: "${./.}/${file}") (filter (x: x != "default.nix") (attrNames (readDir ./.)));

  home = {
    username = user;
    homeDirectory = "/home/${user}";

    file = {
      ".p10k.zsh".source = "${self}/.config/.p10k.zsh";
      "face.jpg".source = "${self}/.local/share/backgrounds/Profile.jpg";
      ".local" = {
        source = "${self}/.local";
        recursive = true;
      };
      ".config" = {
        source = "${self}/.config";
        recursive = true;
      };
    };

    # It‘s perfectly fine and recommended to leave this value
    # at the release version of the first install of this system.
    stateVersion = "24.11";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  programs = {
    ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = { theme = "dark:dark-theme,light:light-theme"; };
    };
    git = {
      enable = true;
      userName = "Excigma";
      userEmail = "git@excigma.xyz";
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      history = {
        size = 10000;
        append = true;
        ignoreAllDups = true;
        extended = false;
        share = true;
      };
      initExtraFirst = ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
         source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';
      initExtra = ''
        zstyle ':autocomplete:history-search-backward:*' list-lines 1000

        ZLE_RPROMPT_INDENT=0
        ZSH_AUTOSUGGEST_USE_ASYNC=true
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40

        # Ctrl + Backspace/Delete to delete word
        bindkey '^H' backward-kill-word
        bindkey "^[[3;5~" kill-word

        # Delete to delete
        bindkey "^[[3~" delete-char

        # Ctrl + ArrowLeft / ArrowRight to move cursor
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word

        # Home/End keys
        bindkey '^[[H' beginning-of-line
        bindkey '^[[F' end-of-line

        zstyle ':autocomplete:*' min-input 3
        zstyle ':autocomplete:*' delay 0.1
      '';
      sessionVariables = {
        VISUAL = "code --wait";
        EDITOR = "code --wait";
        # Needed to make SSH not double echo key presses
        TERM = "xterm-256color";
      };
      shellAliases = {
        ".." = "cd ..";
        "grep" = "grep --color=auto";
        "diff" = "diff --color=auto";
        "neofetch" = "fastfetch --load-config neofetch";
        "ls" = "eza --all --git --icons";
      };
    };
  };

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
