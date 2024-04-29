#!/bin/bash

install() {
  local cmd=""
  local exclude=(
    "*.swp"
    ".editorconfig"
    ".git"
    "LICENSE"
    "README.md"
    "install.sh"
    "profile.ps1"
  )
  local exclude_flags=""
  local msg="These files will be added to or overwritten in the home directory:"
  local overwrite=""
  local reply=""

  for p in "${exclude[@]}"; do
    exclude_flags+="--exclude \"$p\" "
  done

  if [[ -f ~/.system_profile ]]; then
    exclude_flags+="--exclude \".system_profile\" "
  fi

  cmd="\rsync -auhP --no-perms $exclude_flags"
  overwrite="$( \
    eval $cmd --dry-run . ~ | tail -n +4 | sed '1!G;h;$!d' | tail -n +3 \
  )"

  if [[ -z "$overwrite" ]]; then
    echo "Already up-to-date"
    return
  fi

  echo "$msg$overwrite"

  if [[ $SHELL == *"zsh" ]]; then
    read "reply?Continue? (y/N) "
  else
    read -p "Continue? (y/N) " reply
  fi

  if [[ $reply =~ ^[Yy]$ ]]; then
    cmd+=". ~"
		printf "\n$cmd"
    eval "$cmd"

    if [[ $SHELL == *"zsh" ]]; then
      source ~/.zshrc
    else
      source ~/.bash_profile
      bind -f ~/.inputrc
    fi
  fi
}

install

unset install
