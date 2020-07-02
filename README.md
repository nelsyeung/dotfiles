# dotfiles

dotfiles that works on both macOS and Linux, and with bash and zsh. It contains
a custom prompt, useful aliases, Vim configurations and Tmux configurations.

![Terminal screenshot](../media/terminal.png?raw=true)

## Getting started

Make sure a font with powerline is installed. For example, [Cascadia
Code](https://github.com/microsoft/cascadia-code) and [Fira
Code](https://github.com/tonsky/FiraCode).

Install and use immediately with (no need to restart the terminal):

```sh
git clone https://github.com/nelsyeung/dotfiles
cd dotfiles
source install.sh
```

Edit the `.gitconfig` file with your own name and email for Git. For example,

```sh
vi ~/.gitconfig

[user]
  name = Nelson Yeung
  email = nelsyeung@example.com
```

Any extra system specific shell configurations, such as paths and aliases,
should be added in `.system_profile`.

Updating can be done by pulling the updates and running `source install.sh`.
