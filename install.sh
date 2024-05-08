#!/bin/bash
install() {
  local -r cwd="$(pwd)"
  local -r files=(
    .bash_logout
    .bash_profile
    .bashrc
    .general_profile
    .inputrc
    .tmux.conf
    .vim
    .vimrc
    .zshrc
  )

  for file in ${files[@]}; do
    ln -sf "$cwd/$file" ~
    echo "$file installed"
  done

  \rsync -auhP .gitconfig .system_profile ~

  if [[ $SHELL == *"zsh" ]]; then
    source ~/.zshrc
  else
    source ~/.bash_profile
    bind -f ~/.inputrc
  fi
}

install

unset install
