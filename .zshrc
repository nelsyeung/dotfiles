# vim: foldmethod=marker
# General settings {{{
# Source global definitions
if [[ -f /etc/zshrc ]]; then
  source /etc/zshrc
fi

# Source shell independent profile definitions
if [[ -f $HOME/.general_profile ]]; then
  source $HOME/.general_profile
fi

# Prompt parameter expansion, command substitution and arithmetic expansion.
setopt prompt_subst
# Allow comments even in interactive shells.
setopt interactive_comments
# Allow errors to be ignored. Required to make emptytrash work.
setopt null_glob

unsetopt case_glob
setopt extended_glob

HISTFILE=~/.zhistory
HISTSIZE=SAVEHIST=10000
setopt share_history
setopt extended_history
setopt histignorespace

# Search history via up and down arrows
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

autoload -U compinit select-word-style
compinit
select-word-style shell

# 0 -- vanilla completion (abc => abc)
# 1 -- smart case completion (abc => Abc)
# 2 -- word flex completion (abc => A-big-Car)
# 3 -- full flex completion (abc => ABraCadabra)
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'
  zstyle ':completion:*:*:*:*:*' menu select

  bindkey "^[[3~" delete-char
  # }}}

# Prompt {{{
__prompt_command() { # {{{
  local exit_status="$?"
  PROMPT=""
  local reset="%{\e[0%}"
  local black="%{\e[0;30%}"
  local red="%{\e[0;31%}"
  local green="%{\e[0;32%}"
  local yellow="%{\e[0;33%}"
  local orange="%{\e[1;33%}"
  local blue="%{\e[0;34%}"
  local purple="%{\e[0;35%}"
  local violet="%{\e[0;35%}"
  local cyan="%{\e[0;36%}"
  local white="%{\e[0;37%}"

  if tput setaf 1 &> /dev/null; then
    tput sgr0 # reset colors
    reset="%{$(tput sgr0)%}"
    black="%{$(tput setaf 0)%}"
    red="%{$(tput setaf 1)%}"
    green="%{$(tput setaf 64)%}"
    yellow="%{$(tput setaf 136)%}"
    orange="%{$(tput setaf 166)%}"
    blue="%{$(tput setaf 33)%}"
    purple="%{$(tput setaf 125)%}"
    violet="%{$(tput setaf 61)%}"
    cyan="%{$(tput setaf 37)%}"
    white="%{$(tput setaf 15)%}"
  fi

  local foreground=$black

  if [[ $BACKGROUND == "dark" ]]; then
    foreground=$white
  fi

  local exit_color=$foreground
  local cols=$(tput cols)
  local lines=$(tput lines)
  local min_lines=6  # Minimum terminal size before prompt changes

  PROMPT+="$orange@%m "
  PROMPT+="${foreground}: "
  PROMPT+="$red%~ "  # Working directory full path
  PROMPT+="$violet"'$(__prompt_git)'"$reset "  # Git branch and status

  # Add an extra line before the command input if terminal is big
  [[ $lines -ge $min_lines ]] && PROMPT+=$'\n'

  # If last command failed show '$' in red instead of green
  if [[ $exit_status -gt 0 ]]; then
    exit_color=$red
  fi

  exit_color="%(?:%{$foreground%}:%{$red%})"

  PROMPT+="$exit_color$ $reset"  # '$' and reset color
}  # }}}

__prompt_command
# }}}

# Modules {{{
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=(
    $( \
      COMP_WORDS="$words[*]" \
      COMP_CWORD=$(( cword-1 )) \
      PIP_AUTO_COMPLETE=1 $words[1] \
    )
  )
}
compctl -K _pip_completion pip
# }}}

# Source system's specific profile
if [[ -f $HOME/.system_profile ]]; then
  source "$HOME/.system_profile"
fi
