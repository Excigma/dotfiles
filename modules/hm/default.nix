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
    nix-index.enable = true;
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

        nix-run() {
          NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "nixpkgs#$1" \
            --command sh -c "which ''${1#*.} &>/dev/null && exec ''${1#*.} ''${*:2}; exec ''${*:2}"
        }
        nix-shell() {(
          for i in "$@"; do
            if [ -n "$OPTION" ] || [[ "''${i:0:1}" == "-" ]]; then
              ARGS+=" \"$i\""
              OPTION=1; continue
            fi
            NIX_SHELL_PACKAGES+=" $i";
            ARGS+=" \"nixpkgs#$i\""
          done
          eval "NIX_SHELL_PACKAGES=\"''${NIX_SHELL_PACKAGES#* }\" NIXPKGS_ALLOW_UNFREE=1 nix shell --impure $ARGS"
        )}
        where() { readlink -f "$(which "$@")"; }

        SGR () { for i in "$@"; do echo -ne "\e[$i"m; done; }
        nix-find() { nix-locate --no-group --top-level -r "$@"; }
        command_not_found_handler() {(
          CMD="$1"; IFS=$'\n'
          if [ "$NIX_MISSING" = "never" ]; then
            echo "$(SGR 1 34)❭❭ $(SGR 0 1)$CMD$(SGR 0) not found! You can use $(SGR 1)nix-find -wtx /$CMD$(SGR 0) to find it" >&2
            exit 127
          fi
          PACKAGES=($(nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$CMD"))
          case "''${#PACKAGES}" in
            0) echo "$(SGR 1 34)❭❭ $(SGR 0 1)$CMD$(SGR 0) not found! Are you sure you've typed the command correctly?" >&2 ;;
            1) [ "$NIX_MISSING" = "auto" ] &&
                exec nix-shell "''${PACKAGES[1]}" --command "$@";
              echo -n "$(SGR 1 34)❭❭ $(SGR 0 1)$CMD$(SGR 0) not found! Would you like to bring $(SGR 1)''${PACKAGES[1]%.*}$(SGR 0) into scope? " >&2; read
              exec nix-shell "''${PACKAGES[1]}" --command "$@" ;;
            *) [ "$NIX_MISSING" = "always" ] &&
                exec nix-shell "''${PACKAGES[1]}" --command "$@";
              echo "$(SGR 1 34)❭❭ $(SGR 0 1)$CMD$(SGR 0) not found! Would you like to bring one of the following packages into scope?" >&2
              PS3=""; select PKG in ''${PACKAGES[@]%.*}; do exec nix-shell "$PKG" --command "$@"; done ;;
          esac
          exit 127
        )}
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
