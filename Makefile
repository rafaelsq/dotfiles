GO_BKP=~/bk.`go version 2>&1 | ag -o 'go([0-9\.]+)'`

default:
	@echo "make config"
	@echo "make deps"
	@echo "make zsh"
	@echo "make go"
	@echo "make py"
	@echo "make links"
	@echo "make yarn"
	@echo "make nvim"
	@echo "make docker"
	@echo "make fix"

custom:
	@echo "Change GoCode"
	@go get -u github.com/stamblerre/gocode

fix:
	@echo "Fix neovim ctrl+p so it ignores the vendor/node directories"
	@sed -i'' 's/ag --no/ag --ignore-dir=vendor --ignore-dir=node_modules --no/' ~/.config/nvim/plugged/fzf.vim/autoload/fzf/vim.vim

deps:
	@echo "Installing Dependencies"
	@sudo apt update && sudo apt install \
		curl git bison gcc make zsh silversearcher-ag autojump aria2 xsel \
		terminator htop python3-pip tlp powertop fonts-hack

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
		git clone git@github.com:rafaelsq/nuts.zsh-theme.git ~/src/rafaelsq/nuts.zsh-theme && cd ~/src/rafaelsq/nuts.zsh-theme && make; \
	fi

go:
	@if which go > /dev/null; then \
		echo back-up at ${GO_BKP};\
		sudo mv /usr/local/go ${GO_BKP};\
	fi
	@curl --silent https://golang.org/dl/ 2>&1 |\
		ag -o '/go([0-9.]+).linux-amd64.tar.gz' |\
		head -n 1 |\
		xargs -I@ sh -c 'curl -O https://dl.google.com/go@; echo @ | ag -o "(go[0-9\.]+.+)" | xargs -I % sh -c "sudo tar -C /usr/local -xzf % && rm %"'

py:
	@pip3 install jedi autopep8 yapf flake8 pylint python-language-server

nvim:
	@echo "Neovim"
	@yarn global add neovim typescript
	@which pip3 > /dev/null && pip3 install neovim || echo "no pip3 found"
	@which pip2 > /dev/null && pip2 install neovim || echo "no pip2 found"
	@mkdir -p ~/appimage
	# ag -o '/v[0-9\.]+/nvim.appimage' | head -n 1 |
	@curl --silent https://github.com/neovim/neovim/releases |\
		ag -o '/nightly/nvim.appimage' | head -n 1 |\
		xargs -I@ curl -L "https://github.com/neovim/neovim/releases/download@" -o ~/appimage/nvim.appimage_new
	@if [ -f ~/appimage/nvim.appimage_new ]; then \
		[ -f ~/appimage/nvim.appimage ] && mv ~/appimage/nvim.appimage ~/appimage/nvim.appimage$$(date +_%d_%m);\
		mv ~/appimage/nvim.appimage_new ~/appimage/nvim.appimage; \
	fi
	@chmod +x ~/appimage/nvim.appimage
	@echo "plug - https://github.com/junegunn/vim-plug"
	@curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

yarn:
	@echo "yarn https://yarnpkg.com/pt-BR/docs/install"
	@curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	@echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	@sudo apt update && sudo apt install -y yarn
	@echo "yarn basics"
	@yarn global add parcel eslint prettier prettier-eslint-cli eslint-plugin-react eslint-plugin-vue vscode-html-languageserver-bin vls yaml-language-server dockerfile-language-server-nodejs vscode-json-languageserver

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
	@ln -sf ${PWD}/alacritty.yml ~/.config/alacritty/alacritty.yml
	@mkdir -p ~/.config/nvim
	@ln -sf ${PWD}/init.vim ~/.config/nvim/init.vim
	@mkdir -p ~/.config/terminator
	@ln -sf ${PWD}/terminator.cfg ~/.config/terminator/config

docker:
	@sh -c "$$(curl -fsSL https://get.docker.com)"
