# dotfiles

check

```
$ make
```

### Git

to sign commits using your GPG key;

~/.gitconfig_private
```
[user]
    email = <your-email>
    signingkey = <gpg-fingerprint>

[commit]
	gpgsign = true

[alias]
    lg = log --graph --show-signature
```

#### Github

public key; https://github.com/web-flow.gpg  
to add your GPG public key to Github; https://github.com/settings/gpg/new


### Zsh

private settings to ~/.zshrc.local


### Neovim

```bash
> vim
:PlugInstall
```

### Theme

to change the theme, edit alacritty.yml env.
