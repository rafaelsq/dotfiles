ln: nvim zshrc
	@echo "Check README.md"

zshrc:
	echo "source ${PWD}/zshrc" >> ~/.zshrc

nvim:
ifeq ("$(wildcard ~/.config/nvim)", "")
	@mkdir -p ~/.config/nvim
endif
ifeq (!"$(wildcard ~/.config/nvim/init.vim)", "")
	ln -s ${PWD}/init.vim ~/.config/nvim/init.vim
endif
