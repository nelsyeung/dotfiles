# vim: foldmethod=marker: ft=bash
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
__prompt_command() {  # {{{
  local -r exit_status=$?
  local -r lines=$(tput lines)
  local -r reset_color="\[\e[0m\]"

  PS1=""
  PS1+="\$(__prompt_venv)"
  PS1+="\[\e[0;35m\]@\h$reset_color: "
  PS1+="\[\e[0;33m\]\w"  # Working directory full path
  PS1+="\[\e[0;36m\]\$(__prompt_git)"  # Git branch and status
  PS1+=$'\n'
  PS1+="$([[ $exit_status -eq 0 ]] && echo $reset_color || echo "\[\e[0;31m\]")"
  PS1+="> $reset_color"
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
