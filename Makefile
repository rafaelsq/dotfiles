GO_BKP=~/bk.`go version 2>&1 | ag -o 'go([0-9\.]+)'`
ALACRITTY_PATH=`echo ~/src/alacritty/alacritty`
DEFAULT_THEME=onedark

default:
	@echo "make deps"
	@echo "make zsh"
	@echo "make links"
	@echo "make go"
	@echo "make py"
	@echo "make yarn"
	@echo "make nvim"
	@echo "make docker"
	@echo "make alacritty"
	@echo "make fix"
	@echo "make gh"
	@echo "make set theme=[nord|onedark|gruvbox|molokai|dracula]"

custom:
	@echo "Change GoCode"
	@go get -u github.com/stamblerre/gocode

fix:
	@echo "Fix neovim ctrl+p so it ignores the vendor/node directories"
	@sed -i'' 's/ag --no/ag --ignore-dir=vendor --ignore-dir=node_modules --no/' ~/.config/nvim/plugged/fzf.vim/autoload/fzf/vim.vim

deps:
	@echo "Installing Dependencies"

	@echo "yarn https://yarnpkg.com/pt-BR/docs/install"
	@curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	@echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

	@sudo apt update && sudo apt install \
		curl git bison gcc g++ clang make zsh silversearcher-ag autojump aria2 terminator htop python3-pip tlp powertop yarn tmux xsel bat

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
		git clone github.com:rafaelsq/nuts.zsh-theme.git ~/src/rafaelsq/nuts.zsh-theme && cd ~/src/rafaelsq/nuts.zsh-theme && make; \
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
	@which pip3 > /dev/null && pip3 install neovim || echo "no pip3 found"
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
	@echo "yarn basics"
	@yarn global add parcel eslint prettier prettier-eslint-cli eslint-plugin-react eslint-plugin-vue vscode-html-languageserver-bin vls yaml-language-server dockerfile-language-server-nodejs vscode-json-languageserver typescript typescript-language-server

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


alacritty:
	@if [ ! -d ${ALACRITTY_PATH} ]; then \
		mkdir -p ${ALACRITTY_PATH}/../ && cd ${ALACRITTY_PATH}/../ && git clone github.com:alacritty/alacritty.git; \
	fi
	@echo "fetch latest..."
	@cd ${ALACRITTY_PATH} && git fetch origin master && git reset --hard origin/master
	@echo "building..."
	@docker run -it --rm -v ${ALACRITTY_PATH}:/app -w /app rust:1 bash -c "apt update && apt install -y libxcb-xfixes0-dev && cargo build --release"
	@echo "install"
	@sudo cp ${ALACRITTY_PATH}/target/release/alacritty /usr/local/bin
	@echo "creating desktop file"
	@cp ${ALACRITTY_PATH}/extra/linux/Alacritty.desktop ~/.local/share/applications/
	@sed -i'' "s,Icon=Alacritty,Icon=${ALACRITTY_PATH}/extra/logo/alacritty-simple.svg," ~/.local/share/applications/Alacritty.desktop
	@echo "set as default terminal(ctrl + alt + t)"
	@gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'
	@echo "all done, bye"

set:
ifneq ($(theme),)
	@rm ~/.config/alacritty/*.yml
	@ln -sf ${PWD}/alacritty/$(theme).yml ~/.config/alacritty/alacritty.yml
	@ln -sf ${PWD}/alacritty/base.yml ~/.config/alacritty/base.yml
else
	@echo "make set theme=nord"
endif
