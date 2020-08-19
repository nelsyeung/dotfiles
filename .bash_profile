# vim: foldmethod=marker
# General settings {{{
# Source global definitions
if [[ -f /etc/bashrc ]]; then
  source /etc/bashrc
fi

# Source shell independent profile definitions
if [[ -f $HOME/.general_profile ]]; then
  source $HOME/.general_profile
fi

# Don't put duplicate lines in the history
HISTCONTROL=ignoredups:ignorespace
# Enable extended globbing
shopt -s extglob
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob
# Append to bash history file, rather than overwriting it
shopt -s histappend
# Autocorrect typos in path names when using 'cd'
shopt -s cdspell
# }}}

# Prompt {{{
__venv_info() {  # {{{
  if [[ -z "$VIRTUAL_ENV_DISABLE_PROMPT" ]]; then
    if [[ -z "$VIRTUAL_ENV" ]]; then
      echo ""
    else
      echo "($(basename "$VIRTUAL_ENV")) "
    fi
  fi
}  # }}}

__prompt_command() {  # {{{
  local exit_status="$?"
  PS1="$(__venv_info)"
  local reset="\[\e[0m\]"
  local black="\[\e[0;30m\]"
  local red="\[\e[0;31m\]"
  local green="\[\e[0;32m\]"
  local yellow="\[\e[0;33m\]"
  local orange="\[\e[1;33m\]"
  local blue="\[\e[0;34m\]"
  local purple="\[\e[0;35m\]"
  local violet="\[\e[0;35m\]"
  local cyan="\[\e[0;36m\]"
  local white="\[\e[0;37m\]"

  if tput setaf 1 &> /dev/null; then
    tput sgr0 # reset colors
    reset="\[$(tput sgr0)\]"
    black="\[$(tput setaf 0)\]"
    red="\[$(tput setaf 1)\]"
    green="\[$(tput setaf 64)\]"
    yellow="\[$(tput setaf 136)\]"
    orange="\[$(tput setaf 166)\]"
    blue="\[$(tput setaf 32)\]"
    purple="\[$(tput setaf 125)\]"
    violet="\[$(tput setaf 61)\]"
    cyan="\[$(tput setaf 37)\]"
    white="\[$(tput setaf 15)\]"
  fi

  local foreground=$black

  if [[ $BACKGROUND == "dark" ]]; then
    foreground=$white
  fi

  local exit_color=$foreground
  local cols=$(tput cols)
  local lines=$(tput lines)
  local min_lines=6  # Minimum terminal size before prompt changes

  PS1+="$orange@\h "
  PS1+="${foreground}: "
  PS1+="$cyan\w "  # Working directory full path
  PS1+="$violet\$(__prompt_git)$reset "  # Git branch and status

  # Add an extra line before the command input if terminal is big
  [[ $lines -ge $min_lines ]] && PS1+="\n"

  # If last command failed show '$' in red instead of green
  if [[ $exit_status -gt 0 ]]; then
    exit_color=$red
  fi

  PS1+="$exit_color$ $reset"  # '$' and reset color
}  # }}}

export PROMPT_COMMAND=__prompt_command
# }}}

# Modules {{{
if [[ $(uname) == "Darwin" ]]; then
  if [[ -f $(brew --prefix)/etc/bash_completion ]]; then
    source "$(brew --prefix)/etc/bash_completion"
  fi
fi

if [[ -f $HOME/.git-completion.bash ]]; then
  source "$HOME/.git-completion.bash"
fi

_pip_completion()
{
  COMPREPLY=(
    $( \
      COMP_WORDS="${COMP_WORDS[*]}" \
      COMP_CWORD=$COMP_CWORD \
      PIP_AUTO_COMPLETE=1 $1 \
    )
  )
}
complete -o default -F _pip_completion pip
# }}}

# Source system's specific profile
if [[ -f $HOME/.system_profile ]]; then
  source "$HOME/.system_profile"
fi
