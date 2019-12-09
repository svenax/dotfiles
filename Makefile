DIR=/Users/sven/dotfiles
SHELL=/bin/bash

.PHONY:
	symlinks ensure_vundle update_vim

all: symlinks ensure_vundle update_vim
	@echo "Reminder: Vim plugins are managed within Vim with Vundle."

symlinks:
	ln -sf $(DIR)/bash/bash_profile ~/.bash_profile
	ln -sf $(DIR)/bash/bashrc ~/.bashrc
	ln -sf $(DIR)/bash/inputrc ~/.inputrc
	# ln -nsf $(DIR)/emacs/emacs.d ~/.emacs.d
	# ln -nsf $(DIR)/emacs/spacemacs.d ~/.emacs.d
	# ln -sf $(DIR)/emacs/spacemacs ~/.spacemacs
	ln -sf $(DIR)/git/gitconfig ~/.gitconfig
	ln -sf $(DIR)/git/gitignore_global ~/.gitignore_global
	# ln -sf $(DIR)/git/tigrc ~/.tigrc
	ln -sf $(DIR)/latex/latexmkrc ~/.latexmkrc
	ln -nsf $(DIR)/vim/vim ~/.vim
	ln -sf $(DIR)/vim/vimrc ~/.vimrc
	# ln -nsf $(DIR)/vim/vim ~/.nvim
	# ln -sf $(DIR)/vim/vimrc ~/.nvimrc
	ln -sf $(DIR)/zsh/zshenv ~/.zshenv
	ln -sf $(DIR)/zsh/zshrc ~/.zshrc

ensure_vundle: symlinks
	[ ! -d  ~/.vim/bundle/Vundle.vim ] && git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

update_vim: ensure_vundle
	vim +PluginInstall +qall
