default:
	@echo "make config"
	@echo "make deps"
	@echo "make zsh"
	@echo "make go"
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
		terminator htop python3-pip

zsh:
	@if ! which zsh > /dev/null; then \
		echo "oh-my-zsh, https://github.com/robbyrussell/oh-my-zsh"; \
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"; \
		echo "you should logout and login again"; \
	fi
	@if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then \
		echo "zsh autosuggestions"; \
		git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
	fi

go:
	@sudo rm -rf /usr/local/go && curl --silent https://golang.org/dl/ 2>&1 |\
		ag -o 'https://dl.google.com/go/go([0-9.]+).linux-amd64.tar.gz' |\
		head -n 1 |\
		xargs -I@ sh -c 'curl -O @; echo @ | ag -o "(go[0-9\.]+.+)" | xargs -I % sh -c "sudo tar -C /usr/local -xzf % && rm %"'

nvim:
	@echo "Neovim"
	@yarn global add neovim typescript
	@which pip3 > /dev/null || pip3 install neovim
	@if [ ! -d "~/appimage" ]; then \
		mkdir -p ~/appimage; \
	fi
	@rm ~/appimage/nvim.appimage &&\
		curl --silent https://github.com/neovim/neovim/releases |\
		ag -o '/v[0-9\.]+/nvim.appimage' | head -n 1 |\
		xargs -I@ curl -L "https://github.com/neovim/neovim/releases/download@" -o ~/appimage/nvim.appimage
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
	@yarn global add parcel eslint prettier-eslint eslint-plugin-react

config:
	@echo "max watches"
	@sudo sysctl -w fs.inotify.max_user_watches=1048576 && sysctl -p

links:
	@if [ ! -L "~/.zshrc" ]; then \
		echo "~/.zshrc"; \
		rm -f ~/.zshrc; \
		ln -s ${PWD}/zshrc ~/.zshrc; \
	fi
	@if [ ! -L "~/.gitconfig" ]; then \
		echo "~/.gitconfig"; \
		rm -f ~/.gitconfig; \
		ln -s ${PWD}/gitconfig ~/.gitconfig; \
	fi
	@if [ ! -L "~/.eslintrc" ]; then \
		echo "~/.eslintrc"; \
		rm -f ~/.eslintrc; \
		ln -s ${PWD}/eslintrc ~/.eslintrc; \
	fi
	@if [ ! -L "~/.prettierrc" ]; then \
		echo "~/.prettierrc"; \
		rm -f ~/.prettierrc; \
		ln -s ${PWD}/prettierrc ~/.prettierrc; \
	fi
	@if [ ! -L "~/.config/nvim/init.vim" ]; then \
		echo "~/.config/nvim/init.vim"; \
		mkdir -p ~/.config/nvim; \
		rm -f ~/.config/nvim/init.vim; \
		ln -s ${PWD}/init.vim ~/.config/nvim/init.vim; \
	fi
	@if [ ! -L "~/.config/terminator/config" ]; then \
		echo "~/.config/terminator/config"; \
		mkdir -p ~/.config/terminator; \
		rm -f ~/.config/terminator/config; \
		ln -s ${PWD}/terminator.cfg ~/.config/terminator/config; \
	fi

docker:
	@xdg-open "https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository"
