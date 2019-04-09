#!/bin/bash

echo "Checking if Vundle exists at: $HOME/.vim/bundle/Vundle.vim" 
if [ ! -d $HOME/.vim/bundle/Vundle.vim ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

if [ ! -L $HOME/.vimrc ]; then
	echo "Creating .vimrc symlink"
	ln -s $(pwd)/.vimrc $HOME/.vimrc
fi

echo "Running vim plugin install"
vim +PluginInstall +qall

if [ ! -L $HOME/.bash_alias_custom ]; then
	echo "Creating .bash_alias_custom symlink"
	ln -s $(pwd)/.bash_alias_custom $HOME/.bash_alias_custom
fi

if [ ! -L $HOME/.bash_ps1 ]; then
	echo "Creating .bash_ps1 symlink"
	ln -s $(pwd)/.bash_ps1 $HOME/.bash_ps1
fi

if ! grep -q .bash_alias_custom $HOME/.bashrc; then
	echo "Adding .bash_alias_custom to .bashrc"
	echo 'if [ -f $HOME/.bash_alias_custom ]; then' >> $HOME/.bashrc
	echo '	. $HOME/.bash_alias_custom' >> $HOME/.bashrc
	echo "fi" >> $HOME/.bashrc
fi

if ! grep -q .bash_ps1 $HOME/.bashrc; then
	echo "Adding .bash_ps1 to .bashrc"
	echo 'if [ -f $HOME/.bash_ps1 ]; then' >> $HOME/.bashrc
	echo '	. $HOME/.bash_ps1' >> $HOME/.bashrc
	echo "fi" >> $HOME/.bashrc
fi

echo "Done"
