DIR=/Users/sven/dotfiles
SHELL=/bin/bash

all: symlinks ensure_vundle update_vim
	@echo "Reminder: Vim plugins are managed within Vim with Vundle."

symlinks:
	ln -sf $(DIR)/bash/bash_profile ~/.bash_profile
	ln -sf $(DIR)/bash/bashrc ~/.bashrc
	ln -nsf $(DIR)/emacs/emacs.d ~/.emacs.d
	ln -sf $(DIR)/git/gitconfig ~/.gitconfig
	ln -sf $(DIR)/git/gitignore_global ~/.gitignore_global
	ln -nsf $(DIR)/vim/vim ~/.vim
	ln -sf $(DIR)/vim/vimrc ~/.vimrc

ensure_vundle: symlinks
	[ ! -d  ~/.vim/bundle/Vundle.vim ] && git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

update_vim: ensure_vundle
	vim +PluginInstall +qall
