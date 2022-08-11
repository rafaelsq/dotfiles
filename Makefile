GO_BKP=~/bk.`go version 2>&1 | ag -o 'go([0-9\.]+)'`
DEFAULT_THEME=onedark

default:
	@echo "make arch"
	@echo "make ubuntu"
	@echo "make mac"
	@echo "make set theme=[nord|onedark|gruvbox|molokai|dracula]"

ubuntu:
	@echo "Installing Dependencies"
	@echo "for NVM, check https://github.com/nvm-sh/nvm"
	@sudo apt update && sudo apt install \
		curl git bison gcc g++ clang make zsh silversearcher-ag autojump aria2 terminator htop python3-pip tlp powertop tmux xsel bat

mac:
	brew install fzf tmux the_silver_searcher autojump
	brew install --HEAD neovim

arch:
	mkdir -p ~/src/yay && cd ~/src/yay && git clone https://aur.archlinux.org/yay.git && makepkg -si
	sudo pacman -S fzf tmux alacritty python-pip aria2 the_silver_searcher go npm yarn bat
	yay -S autojump google-chrome neovim-nightly-bin
	@echo "Now"
	@echo "make zsh"
	@echo "make tmux"
	@echo "make nvim"
	@echo "make lsp"
	@echo "make links"

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
	@echo "Don't forget to ctrl+I to install and ctrl+U to update plugins"

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
		git clone https://github.com/rafaelsq/nuts.zsh-theme.git ~/src/rafaelsq/nuts.zsh-theme && cd ~/src/rafaelsq/nuts.zsh-theme && make; \
	fi

go:
	@if which go > /dev/null; then \
		echo back-up at ${GO_BKP};\
		sudo mv /usr/local/go ${GO_BKP};\
	fi
	@curl --silent https://go.dev/dl/ 2>&1 |\
		ag -o '/go([0-9.]+).linux-amd64.tar.gz' |\
		head -n 1 |\
		xargs -I@ sh -c 'curl -O https://dl.google.com/go@; echo @ | ag -o "(go[0-9\.]+.+)" | xargs -I % sh -c "sudo tar -C /usr/local -xzf % && rm %"'

py:
	@pip3 install jedi autopep8 yapf flake8 pylint python-language-server

nvim:
	@echo "Neovim"
	@which pip3 > /dev/null && pip3 install neovim || echo "no pip3 found"
	@echo "packer - https://github.com/wbthomason/packer.nvim"
	@git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

lsp:
	@echo "LSP install"
	# html, css, json and eslint: https://github.com/hrsh7th/vscode-langservers-extracted
	yarn global add typescript-language-server vscode-langservers-extracted yaml-language-server eslint dockerfile-language-server-nodejs pyright
	go install golang.org/x/tools/gopls@latest

yarn:
	@npm install --global yarn
	@echo "yarn basics"
	@yarn global add parcel eslint prettier prettier-eslint-cli eslint-plugin-react eslint-plugin-vue vscode-html-languageserver-bin vls yaml-language-server dockerfile-language-server-nodejs vscode-json-languageserver typescript typescript-language-server vscode-langservers-extracted

config:
	@echo "max watches"
	@sudo sysctl -w fs.inotify.max_user_watches=1048576 && sysctl -p

links:
	@echo "links"
	@ln -sf ${PWD}/zshrc ~/.zshrc
	@ln -sf ${PWD}/gitconfig ~/.gitconfig
	@ln -sf ${PWD}/eslintrc ~/.eslintrc
	@ln -sf ${PWD}/prettierrc ~/.prettierrc
	@ln -sf ${PWD}/.tmux.conf ~/.tmux.conf
	@mkdir -p ~/.config/alacritty
	@ln -sf ${PWD}/alacritty/${DEFAULT_THEME}.yml ~/.config/alacritty/alacritty.yml
	@ln -sf ${PWD}/alacritty/base.yml ~/.config/alacritty/base.yml
	@mkdir -p ~/.config/nvim
	@ln -sf ${PWD}/init.lua ~/.config/nvim/init.lua
	@mkdir -p ~/.config/terminator
	@ln -sf ${PWD}/terminator.cfg ~/.config/terminator/config
	@rm -rf ~/.config/nvim/UltiSnips
	@ln -sf ${PWD}/ultisnips ~/.config/nvim/UltiSnips

docker:
	@sh -c "$$(curl -fsSL https://get.docker.com)"

gh:
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
	sudo apt-add-repository https://cli.github.com/packages
	sudo apt update
	sudo apt install gh

set:
ifneq ($(theme),)
	@rm ~/.config/alacritty/*.yml
	@ln -sf ${PWD}/alacritty/$(theme).yml ~/.config/alacritty/alacritty.yml
	@ln -sf ${PWD}/alacritty/base.yml ~/.config/alacritty/base.yml
else
	@echo "make set theme=nord"
endif
