defaul:
	@cho "try make all"

all: install nvim zsh git eslint
	@echo "Check README.md"

install:
	./install.sh

git:
ifeq ("$(wildcard ~/.gitconfig)", "")
	ln -s ${PWD}/gitconfig ~/.gitconfig
endif

eslint:
ifeq ("$(wildcard ~/.eslintrc)", "")
	ln -s ${PWD}/eslintrc ~/.eslintrc
endif

zsh:
	echo "source ${PWD}/zshrc" >> ~/.zshrc

nvim:
ifeq ("$(wildcard ~/.config/nvim)", "")
	@mkdir -p ~/.config/nvim
endif
ifeq ("$(wildcard ~/.config/nvim/init.vim)", "")
	ln -s ${PWD}/init.vim ~/.config/nvim/init.vim
endif
