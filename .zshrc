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

HISTSIZE=SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt share_history
setopt extended_history
setopt histignorespace

# If VISUAL or EDITOR is set to vim, vim terminal will run zsh vim mode which
# unbinds these.
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

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
preexec() {
  print -nP "%f"
}

__prompt_command() { # {{{
  local -r reset_color="%f"

  PROMPT=""
  PROMPT+="\$(__prompt_venv)"
  PROMPT+="%F{magenta}@%m$reset_color: "
  PROMPT+="%F{11}%~%b"  # Working directory full path
  PROMPT+="%F{cyan}\$(__prompt_git)"  # Git branch and status
  PROMPT+=$'\n'
  PROMPT+="%(?:%{$reset_color%}:%{%F{red}%})> $reset_color"
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
