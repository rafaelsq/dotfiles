GO_BKP=~/bk.`go version 2>&1 | ag -o 'go([0-9\.]+)'`
DEFAULT_THEME=onedark
UNAME_S := $(shell uname -s)

default:
	@echo "make arch"
	@echo "make ubuntu"
	@echo "make mac"
	@echo "make set theme=[nord|onedark|gruvbox|molokai|dracula]"

ubuntu:
	@echo "Installing Dependencies"
	@echo "for NVM, check https://github.com/nvm-sh/nvm"
	@sudo apt update && sudo apt install \
		curl git zsh silversearcher-ag autojump aria2 terminator htop python3-pip tmux xsel bat alacritty nodejs npm
	@sudo snap install nvim --classic
	@sudo snap install go --classic
	@sudo snap install kubectl --classic
	@sudo snap install k9s
	@npm install --global yarn
	# https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
	# https://github.com/derailed/k9s/releases/download/latest/k9s_Linux_amd64.tar.gz

mac:
	brew install fzf tmux the_silver_searcher autojump derailed/k9s/k9s gnupg go neovim
	brew tap homebrew/cask-fonts
	brew install --cask font-hack-nerd-font
	brew install node yarn

arch:
	# Step 1
	# enable AUR from app center
	# Step 2
	# sudo pamac install make
	sudo pamac install python-pip aria2 the_silver_searcher go npm yarn bat k9s kitty \
		autojump google-chrome neovim-nightly-bin docker-desktop docker-compose-v2-git # aur
	sudo usermod -aG docker ${USER}
	pip3 install --upgrade pynvim --break-system-packages
	@echo "Now"
	@echo "make zsh"
	@echo "make tmux"
	@echo "make nvim"
	@echo "make lsp"
	@echo "make links"
	@echo "don't forget to run make set theme=<any> for kitty to work"

tmux:
	@echo "tmux tpm"
	@if [ ! -d ~/.tmux/plugins/tpm ]; then \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
	else \
		cd ~/.tmux/plugins/tpm && git pull origin master; \
	fi
	@if [ ! -d ~/.tmux/plugins/onedark ]; then \
		git clone https://github.com/odedlaz/tmux-onedark-theme ~/.tmux/plugins/onedark; \
	else \
		cd ~/.tmux/plugins/onedark && git pull origin master; \
	fi
	@if [ ! -d ~/.tmux/plugins/nord ]; then \
		git clone https://github.com/arcticicestudio/nord-tmux ~/.tmux/plugins/nord; \
	else \
		cd ~/.tmux/plugins/nord && git pull origin master; \
	fi
	@if [ ! -d ~/.tmux/plugins/dracula ]; then \
		git clone https://github.com/dracula/tmux ~/.tmux/plugins/dracula; \
	else \
		cd ~/.tmux/plugins/dracula && git pull origin master; \
	fi
	@if [ ! -d ~/.tmux/plugins/gruvbox ]; then \
		git clone https://github.com/egel/tmux-gruvbox ~/.tmux/plugins/gruvbox; \
	else \
		cd ~/.tmux/plugins/gruvbox && git pull origin master; \
	fi
	@if [ ! -d ~/.tmux/plugins/ayu ]; then \
		git clone https://github.com/jibingeo/tmux-colors-ayu ~/.tmux/plugins/ayu; \
	else \
		cd ~/.tmux/plugins/ayu && git pull origin master; \
	fi
	@if [ ! -d ~/.tmux/plugins/rose-pine ]; then \
		git clone https://github.com/rose-pine/tmux ~/.tmux/plugins/rose-pine; \
	else \
		cd ~/.tmux/plugins/rose-pine && git pull origin main; \
	fi
	@if [ ! -d ~/.tmux/plugins/catppuccin ]; then \
		git clone https://github.com/catppuccin/tmux ~/.tmux/plugins/catppuccin; \
	else \
		cd ~/.tmux/plugins/catppuccin && git pull origin main; \
	fi
	@echo "Don't forget to prefix+I to install and prefix+U to update plugins"

zsh:
	@echo "Oh My ZSH"
	@if [ ! -d ~/.oh-my-zsh ]; then \
		echo "oh-my-zsh, https://github.com/robbyrussell/oh-my-zsh"; \
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"; \
		echo "you should logout and login again"; \
	fi
	@if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then \
		echo "zsh autosuggestions"; \
		git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
		chsh -s $$(which zsh); \
	fi
	@mkdir -p ~/src/rafaelsq
	@if [ ! -d ~/src/rafaelsq/nuts.zsh-theme ]; then \
		echo "Nuts Theme"; \
		git clone https://github.com/rafaelsq/nuts.zsh-theme.git ~/src/rafaelsq/nuts.zsh-theme; \
	fi
	@cd ~/src/rafaelsq/nuts.zsh-theme && make

go:
	@if which go > /dev/null; then \
		echo back-up at ${GO_BKP};\
		sudo mv /usr/local/go ${GO_BKP};\
	fi
	@curl --silent https://go.dev/dl/ 2>&1 |\
		ag -o "/go([0-9.]+).`uname | tr A-Z a-z`-amd64.tar.gz" |\
		head -n 1 |\
		xargs -I@ sh -c 'curl -O https://dl.google.com/go@; echo @ | ag -o "(go[0-9\.]+.+)" | xargs -I % sh -c "sudo tar -C /usr/local -xzf % && rm %"'

py:
	@python3 -m pip install autopep8 flake8 pylint

nvim:
	@echo "Neovim"
	@python3 -m pip install neovim

lsp:
	@echo "LSP install"
	# html, css, json and eslint: https://github.com/hrsh7th/vscode-langservers-extracted
	yarn global add typescript-language-server vscode-langservers-extracted yaml-language-server eslint@8 \
		dockerfile-language-server-nodejs graphql graphql-language-service-cli @fsouza/prettierd vls pyright
	go install golang.org/x/tools/gopls@latest
	go install github.com/nametake/golangci-lint-langserver@latest
	pip3 install --upgrade black pycodestyle --break-system-packages
	@if [ -x "`which yay 2>/dev/null`" ]; then \
		yay -S lua-language-server; \
	elif [ -x "`wich brew 2>/dev/null`" ]; then \
		brew install lua-language-server; \
	else \
		echo "you should learn how to install lua-language-server"; \
	fi
	@if [ -x "`which rustup 2>/dev/null`" ]; then \
		rustup component add rust-analyzer; \
	fi

rust:
	@curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

links:
	@echo "links"
	@ln -sf ${PWD}/zshrc ~/.zshrc
	@ln -sf ${PWD}/gitconfig ~/.gitconfig
	@ln -sf ${PWD}/prettierrc ~/.prettierrc
	@ln -sf ${PWD}/.tmux.conf ~/.tmux.conf
	@mkdir -p ~/.config/alacritty
	@rm -rf ~/.config/alacritty/*.toml
	@ln -sf ${PWD}/alacritty/${DEFAULT_THEME}.toml ~/.config/alacritty/alacritty.toml
ifeq ($(UNAME_S), Darwin)
	@ln -sf ${PWD}/alacritty/base.toml ~/.config/alacritty/b.toml
	@ln -sf ${PWD}/alacritty/mac.toml ~/.config/alacritty/base.toml
else
	@ln -sf ${PWD}/alacritty/base.toml ~/.config/alacritty/base.toml
	@mkdir -p ~/.config/kitty
	@ln -sf ${PWD}/kitty.conf ~/.config/kitty/kitty.conf
	@mkdir -p ~/.gnupg
	@ln -sf ${PWD}/gpg-agent.conf ~/.gnupg/gpg-agent.conf
endif
	@mkdir -p ~/.config/kitty
	@ln -sf ${PWD}/kitty.conf ~/.config/kitty/kitty.conf
	@mkdir -p ~/.config/nvim/lua
	@ln -sf ${PWD}/init.lua ~/.config/nvim/init.lua
	@ln -sf ${PWD}/cfg.lua ~/.config/nvim/lua/cfg.lua
	@mkdir -p ~/.config/terminator
	@ln -sf ${PWD}/terminator.cfg ~/.config/terminator/config
	@rm -rf ~/.config/nvim/UltiSnips
	@ln -sf ${PWD}/ultisnips ~/.config/nvim/UltiSnips
	@mkdir -p ~/.config/wireplumber/policy.lua.d
	@ln -sf ${PWD}/11-bluetooth-policy.lua ~/.config/wireplumber/policy.lua.d

docker:
	@sh -c "$$(curl -fsSL https://get.docker.com)"

gh:
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
	sudo apt-add-repository https://cli.github.com/packages
	sudo apt update
	sudo apt install gh

set:
ifneq ($(theme),)
	@rm -f ~/.config/alacritty/*.toml
	@ln -sf ${PWD}/alacritty/$(theme).toml ~/.config/alacritty/alacritty.toml
ifeq ($(UNAME_S), Darwin)
	@ln -sf ${PWD}/alacritty/base.toml ~/.config/alacritty/b.toml
	@ln -sf ${PWD}/alacritty/mac.toml ~/.config/alacritty/base.toml
else
	@ln -sf ${PWD}/alacritty/base.toml ~/.config/alacritty/base.toml
endif
	# kitty
	@echo <<EOF\
		env THEME=$(theme) \
>~/.config/kitty/themes.conf
ifeq ($(theme), onedark)
	kitten themes --config-file-name=themes.conf one dark
else ifeq ($(theme), rose-pine)
	kitten themes --config-file-name=themes.conf Rosé Pine
else ifeq ($(theme), catppuccin-frappe)
	kitten themes --config-file-name=themes.conf Catppuccin-Frappe
else
	kitten themes --config-file-name=themes.conf $(theme)
endif

else
	@echo "make set theme=nord"
endif
