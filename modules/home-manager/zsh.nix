{ pkgs, lib, ... }:
let
  inherit (lib) getExe;
in
{
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
      initContent = lib.mkMerge [
        (lib.mkBefore ''
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          if [ -f ~/.config/.p10k.zsh ]; then source ~/.config/.p10k.zsh
          else
            source /etc/powerlevel10k/.p10k.zsh
          fi
        '')
        ''
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
        ''
      ];
      sessionVariables = {
        VISUAL = "${getExe pkgs.vscode} --wait";
        EDITOR = "${getExe pkgs.vscode} --wait";
        MOZ_USE_XINPUT2 = "1";
        # NIXOS_OZONE_WL = "1";
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
