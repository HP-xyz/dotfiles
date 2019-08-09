#!/bin/bash
set -e

if [ ! -f $HOME/.zshrc ] && [ ! -L $HOME/.zshrc ]; then
	echo "Install zsh first"
	exit 1
fi

if [ ! -d $HOME/.oh-my-zsh ]; then
	echo "Install oh-my-zsh first"
	exit 1
fi


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

if [ ! -L $HOME/.aliases ]; then
	echo "Creating .aliases symlink"
	ln -s $(pwd)/.aliases $HOME/.aliases
fi

### BASH STUFF
if [ ! -L $HOME/.bash_ps1 ]; then
	echo "Creating .bash_ps1 symlink"
	ln -s $(pwd)/.bash_ps1 $HOME/.bash_ps1
fi

if ! grep -q .aliases $HOME/.bashrc; then
	echo "Adding .aliases to .bashrc"
	echo 'if [ -f $HOME/.aliases ]; then' >> $HOME/.bashrc
	echo '	. $HOME/.aliases' >> $HOME/.bashrc
	echo "fi" >> $HOME/.bashrc
fi

if ! grep -q .bash_ps1 $HOME/.bashrc; then
	echo "Adding .bash_ps1 to .bashrc"
	echo 'if [ -f $HOME/.bash_ps1 ]; then' >> $HOME/.bashrc
	echo '	. $HOME/.bash_ps1' >> $HOME/.bashrc
	echo "fi" >> $HOME/.bashrc
fi

### ZSH STUFF
if [ ! -d $HOME/.zsh ]; then
	echo "Creating zsh custom directory"
	mkdir $HOME/.zsh
fi

if [ -f $HOME/.zshrc ]; then
	echo "Creating .zshrc symlink"
	rm $HOME/.zshrc
	ln -s $(pwd)/.zshrc $HOME/.zshrc
fi

if ! grep -q .aliases $HOME/.zshrc; then
	echo "Adding .aliases to .bashrc"
	echo 'if [ -f $HOME/.aliases ]; then' >> $HOME/.zshrc
	echo '	. $HOME/.aliases' >> $HOME/.zshrc
	echo "fi" >> $HOME/.zshrc
fi

if [ ! -L $HOME/.tmux.conf ]; then
	echo "Creating .tmux.conf symlink"
	ln -s $(pwd)/.tmux.conf $HOME/.tmux.conf
fi

if [ ! -L $HOME/shell ]; then
	echo "Creating shell symlink"
	ln -s $(pwd)/shell $HOME/shell
fi

if [ ! -L $HOME/.oh-my-zsh/themes/agnoster-hp.zsh-theme ]; then
	echo "Creating .oh-my-zsh/themes/agnoster-hp.zsh-theme symlink"
	ln -s $(pwd)/.oh-my-zsh/themes/agnoster-hp.zsh-theme $HOME/.oh-my-zsh/themes/agnoster-hp.zsh-theme
fi

if [ ! -f "$HOME/.zsh/themes/spaceship-prompt" ]; then
	echo "Creating spaceship.zsh-theme symlink"
	git clone https://github.com/denysdovhan/spaceship-prompt.git "$HOME/.zsh/themes/spaceship-prompt"
	ln -s "$HOME/themes/spaceship-prompt/spaceship.zsh-theme" "$HOME/.zsh/themes/spaceship.zsh-theme"
fi

echo "Done"
