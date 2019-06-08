default:
	@echo "make config"
	@echo "make deps"
	@echo "make zsh"
	@echo "make go"
	@echo "make links"
	@echo "make yarn"
	@echo "make nvim"

deps:
	@echo "Installing Dependencies"
	@sudo apt update && sudo apt install \
		curl git bison gcc make zsh silversearcher-ag autojump aria2 xsel

zsh:
	@echo "oh-my-zsh, https://github.com/robbyrussell/oh-my-zsh"
	@./zsh.sh
	@echo "source ${PWD}/zshrc" >> ~/.zshrc
	@echo "you should logout and login again"

go:
	@xdg-open https://golang.org/dl/

nvim:
	@echo "Neovim"
	@yarn global add neovim
	@mkdir -p ~/appimage
	@xdg-open https://github.com/neovim/neovim/releases
	@chmod +x ~/appimage/nvim.appimage
	@echo "plug - https://github.com/junegunn/vim-plug"
	@curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

yarn:
	@echo "yarn https://yarnpkg.com/pt-BR/docs/install"
	@curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	@echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	@sudo apt update && apt install -y yarn
	@echo "yarn basics"
	@yarn global add parcel eslint prettier-eslint eslint-plugin-react

config:
	@echo "max watches"
	@sudo sysctl -w fs.inotify.max_user_watches=1048576 && sysctl -p

links:
ifeq ("$(wildcard ~/.gitconfig)", "")
	ln -s ${PWD}/gitconfig ~/.gitconfig
endif
ifeq ("$(wildcard ~/.eslintrc)", "")
	ln -s ${PWD}/eslintrc ~/.eslintrc
endif
ifeq ("$(wildcard ~/.config/nvim)", "")
	@mkdir -p ~/.config/nvim
endif
ifeq ("$(wildcard ~/.config/nvim/init.vim)", "")
	ln -s ${PWD}/init.vim ~/.config/nvim/init.vim
endif
