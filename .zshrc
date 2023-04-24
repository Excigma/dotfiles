if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

bindkey -e

CASE_SENSITIVE="false"
DISABLE_AUTO_TITLE="true"
TIMEFMT=$'\nuser\t%*U\nsys\t%*S\ntotal\t%*E'
ZLE_RPROMPT_INDENT=0
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Mmm color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ls='ls --color=auto --human-readable --group-directories-first --classify'

# I'm a bit lazy sometimes
alias sudoedit='EDITOR="code -w" sudoedit'
alias config='/usr/bin/git --git-dir=/home/excigma/.git --work-tree=/home/excigma'
alias neofetch='fastfetch --load-config neofetch'
alias ssh='TERM=xterm-256color ssh'
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0'


# I'm very lazy
alias ..='cd ..'

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

# File manager keybinds (Alt + Left and Alt + Up)
cdUndoKey() {
  popd
  zle       reset-prompt
  print
  ls
  zle       reset-prompt
}

cdParentKey() {
  pushd ..
  zle      reset-prompt
  print
  ls
  zle       reset-prompt
}

zle -N                 cdParentKey
zle -N                 cdUndoKey
bindkey '^[[1;3A'      cdParentKey
bindkey '^[[1;3D'      cdUndoKey

# Ask to correct command typos
setopt correct

# Ignore lines prefixed with # in interactive mode
setopt interactivecomments

# Ignore duplicate entries in history
setopt hist_ignore_dups

# Stop getting jumpscared by beeps
unsetopt beep

# Make completions ignore folder case
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion::complete:*' gain-privileges 1

# Ignore completion functions for not installed packages
zstyle ':completion:*:functions' ignored-patterns '_*'

# Hide usernames for ssh autocomplete
zstyle ':completion:*:ssh:*:users' hidden true

autoload -Uz compinit
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

# antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
source ~/.zsh_plugins.sh

# Arch Linux command not found prompt
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=(
        ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
    )
    if (( ${#entries[@]} ))
    then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}"
        do
            # (repo package version file)
            local fields=(
                ${(0)entry}
            )
            if [[ "$pkg" != "${fields[2]}" ]]
            then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
