# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

CASE_SENSITIVE="false"
DISABLE_AUTO_TITLE="true"
TIMEFMT=$'\nuser\t%*U\nsys\t%*S\ntotal\t%*E'
ZLE_RPROMPT_INDENT=0
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Mmm color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls='ls --color=auto'
alias dir='ls --color=auto'

alias config='/usr/bin/git --git-dir=/home/excigma/.cfg/ --work-tree=/home/excigma'

# Ctrl + Backspace to delete word
bindkey '^H' backward-kill-word
# Delete to delete
bindkey "^[[3~" delete-char
# Ctrl + ArrowLeft/ArrowRight to move cursor
bindkey ";5C" forward-word
bindkey ";5D" backward-word

# Ask to correct command typos
setopt correct

autoload -Uz compinit
compinit

# antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
source ~/.zsh_plugins.sh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
