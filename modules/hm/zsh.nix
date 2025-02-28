{ pkgs, lib, ... }:
let inherit (lib) getExe;
in {
  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--no-cmd" ];
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
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        if [ -f ~/.p10k.zsh ]; then source ~/.p10k.zsh
        else
          source /etc/powerlevel10k/.p10k.zsh
        fi
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

        function ls() {
          if command -v eza >/dev/null 2>&1; then
              eza --all --git --icons "$@"
          else
              command ls --color=auto "$@"
          fi
        }

        function cd() {
          if command -v zoxide >/dev/null 2>&1; then
              __zoxide_z "$@"
          else
              command cd "$@"
          fi
        }

        sudo() {
          if [[ "$1" == "-s" && -z "$2" ]]; then
              echo ""
          fi
          command sudo "$@"
        }

        nix-run() {
          NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "nixpkgs#$1" \
            --command sh -c "which ''${1#*.} &>/dev/null && exec ''${1#*.} ''${*:2}; exec ''${*:2}"
        }
        nix-shell() {(
          ARGS=()
          for i in "$@"; do
            if [[ -n $OPTION || $i[1] = - ]]; then
              ARGS+="$i" OPTION=1
               continue
            fi
            ARGS+="nixpkgs#$i"
          done
          IN_NIX_SHELL=impure NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "''${ARGS[@]}"
        )}
        where() { readlink -f "$(which "$@")"; }

        nix-find() { ${pkgs.nix-index}/bin/nix-locate --no-group --top-level -r "$@"; }
        command_not_found_handler() {(
          CMD="$1" IFS=$'\n'
          SGR() { echo -ne "\e[''${(j:m\e[:)@}m"; }
          if [ "$NIX_MISSING" = "never" ]; then
            echo "$(SGR 1 34)❭❭ $(SGR 0 1)$CMD$(SGR 0) not found! You can use $(SGR 1)nix-find -wtx /$CMD$(SGR 0) to find it" >&2
            exit 127
          fi
          PACKAGES=($(${pkgs.nix-index}/bin/nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$CMD"))
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
        VISUAL = "${getExe pkgs.vscode} --wait";
        EDITOR = "${getExe pkgs.vscode} --wait";
        BROWSER = "${getExe pkgs.firefox-devedition}";
        MOZ_USE_XINPUT2 = "1";
      };
      shellAliases = {
        ".." = "cd ..";
        "grep" = "grep --color=auto";
        "diff" = "diff --color=auto";
        "neofetch" = "fastfetch --load-config neofetch";
      };
    };
  };
}
