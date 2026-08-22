{ pkgs, lib, ... }:
let
  inherit (lib) getExe;
in
{
  home.packages = [
    pkgs.zsh-autocomplete
    pkgs.zsh-fast-syntax-highlighting
  ];
  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      # zsh-autocomplete handles completion init itself.
      enableCompletion = false;
      # Typing a directory name cd's into it (mirrors the phone's `setopt AUTO_CD`).
      autocd = true;
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
          # zsh-autocomplete completes asynchronously by spawning a throwaway
          # interactive zsh in a pty (`.autocomplete:async:pty`) for every
          # completion. That shell re-sources `~/.zshrc`; its process tree is
          # `main-zsh -> async subshell (zsh) -> async pty (zsh)`, i.e. both its
          # parent and grandparent are `zsh`. A real terminal launches zsh from a
          # terminal emulator (ghostty, kitty, ...), so that pattern uniquely
          # identifies the async pty. We use it to skip the heavy prompt/highlight
          # stack there -- it only needs the completion plugin.
          # This drops each async completion from ~150ms to ~30ms.
          if [[ ''${$(ps -o comm= -p $PPID):-} == zsh &&
                ''${$(ps -o comm= -p ''${$(ps -o ppid= -p $PPID):-}):-} == zsh ]]; then
            typeset -g __za_async_pty=1
          fi
          if [[ -z $__za_async_pty ]]; then
            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
            if [ -f ~/.config/.p10k.zsh ]; then source ~/.config/.p10k.zsh
            else
              source /etc/powerlevel10k/.p10k.zsh
            fi
          fi
        '')
        # fast-syntax-highlighting: load before zsh-autocomplete so its
        # widgets don't trip fsh's unhandled-widget check (matches the phone).
        (lib.mkOrder 550 ''
          if [[ -z $__za_async_pty ]]; then
            source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
          fi
        '')
        # Live completion menu: real-time type-ahead completion with a
        # selectable menu, plus Ctrl+R history search. Sourced before
        # compinit/aliases per the plugin's requirements. Loaded in the async
        # pty too, since that engine is what computes the candidates.
        (lib.mkOrder 560 ''
          source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
          bindkey              '^I' menu-select
          bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
        '')
        ''
            zstyle ':autocomplete:history-search-backward:*' list-lines 1000

          # zsh-autocomplete needs # to be treated as a comment
          # (marlonrichert/zsh-autocomplete#724), otherwise its compadd calls
          # fail with "parse error in command substitution" and no menu shows.
          # (=autocomplete's async pty shell sources this too.)
          setopt interactivecomments

          if [[ -z $__za_async_pty ]]; then

          ZLE_RPROMPT_INDENT=0
          ZSH_AUTOSUGGEST_USE_ASYNC=true
          ZSH_AUTOSUGGEST_STRATEGY=(history completion)
          ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40

          # Insert the grey suggestion with Ctrl+Space
          bindkey '^ ' autosuggest-accept

          # Expand history references like `!!` / `!$` when pressing space
          bindkey ' ' magic-space

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

          function _pip_completion() {
            local words cword
            read -Ac words
            read -cn cword
            reply=(
              $(
                COMP_WORDS="$words[*]"
                COMP_CWORD=$(( cword-1 ))
                PIP_AUTO_COMPLETE=1 $words 2>/dev/null
              )
            )
          }
          compctl -K _pip_completion pip pip3

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

          fi  # [[ -z $__za_async_pty ]]
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
