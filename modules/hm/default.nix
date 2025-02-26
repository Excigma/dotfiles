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
      settings = {
        theme = "dark:dark-theme,light:light-theme";
        term = "xterm-256color";
        confirm-close-surface = false;
        shell-integration-features = true;
        keybind = [ "ctrl+t=new_tab" "ctrl+w=close_tab" ];
      };
      themes = {
        light-theme = {
          palette = [
            "0=#000000"
            "1=#AA3731"
            "2=#448C27"
            "3=#CB9000"
            "4=#325CC0"
            "5=#7A3E9D"
            "6=#0083B2"
            "7=#BBBBBB"
            "8=#777777"
            "9=#F05050"
            "10=#60CB00"
            "11=#FFBC5D"
            "12=#007ACC"
            "13=#E64CE6"
            "14=#00AACB"
            "15=#FFFFFF"
          ];
          background = "#F7F7F7";
          foreground = "#434343";
          cursor-color = "#434343";
          cursor-text = "#F7F7F7";
          selection-background = "#BBBBBB";
          selection-foreground = "#434343";
        };
        dark-theme = {
          palette = [
            "0=#0E1415"
            "1=#e25d56"
            "2=#73ca50"
            "3=#e9bf57"
            "4=#4a88e4"
            "5=#915caf"
            "6=#23acdd"
            "7=#f0f0f0"
            "8=#777777"
            "9=#f36868"
            "10=#88db3f"
            "11=#f0bf7a"
            "12=#6f8fdb"
            "13=#e987e9"
            "14=#4ac9e2"
            "15=#FFFFFF"
          ];
          background = "#1e1e1e";
          foreground = "#CECECE";
          cursor-color = "#CECECE";
          cursor-text = "#0E1415";
          selection-background = "#f0f0f0";
          selection-foreground = "#1e1e1e";
        };
      };
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
