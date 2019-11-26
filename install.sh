#!/bin/bash
set -e
ZSH_THEME="powerlevel10k"

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

### i3 STUFF ###
if [ ! -L $HOME/.bash_ps1 ]; then
    echo "Creating symlinks for i3"
    mkdir -p $HOME/.config/i3
    ln -s $(pwd)/.config/i3/config $HOME/.config/i3/config
    ln -s $(pwd)/i3scripts $HOME/i3scripts
    ln -s $(pwd)/.i3blocks.conf $HOME/.i3blocks.conf
    echo "exec i3" >> $HOME/.xinitrc
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

if [ ! -d $HOME/antigen ]; then
    echo "Cloning antigen"
    git clone https://github.com/zsh-users/antigen.git $HOME/antigen
fi

if [ $ZSH_THEME = "agnoster" ]; then
    if [ ! -L $HOME/.oh-my-zsh/themes/agnoster-hp.zsh-theme ]; then
	    echo "Creating .oh-my-zsh/themes/agnoster-hp.zsh-theme symlink"
    	ln -s $(pwd)/.oh-my-zsh/themes/agnoster-hp.zsh-theme $HOME/.oh-my-zsh/themes/agnoster-hp.zsh-theme
    fi
elif [ $ZSH_THEME = "spaceship" ]; then
    if [ ! -L "$HOME/.zsh/themes/spaceship.zsh-theme" ]; then
	    echo "Cloning and symlinking spaceship-prompt"
    	git clone https://github.com/denysdovhan/spaceship-prompt.git "$HOME/.zsh/themes/spaceship-prompt"
    	ln -s "$HOME/.zsh/themes/spaceship-prompt/spaceship.zsh-theme" "$HOME/.zsh/themes/spaceship.zsh-theme"
    else
    	echo "Updating spaceship-prompt"
    	git -C $HOME/.zsh/themes/spaceship-prompt pull
    fi

    echo "Disabling unused spaceship parts:"
    echo "  -hg"
    sed --follow-symlinks -i -e "s/hg            # Mercurial section (hg_branch  + hg_status)/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh 
    echo "  -package"
    sed --follow-symlinks -i -e "s/package       # Package version/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -nodejs"
    sed --follow-symlinks -i -e "s/node          # Node.js section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -ruby"
    sed --follow-symlinks -i -e "s/ruby          # Ruby section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -elixir"
    sed --follow-symlinks -i -e "s/elixir        # Elixir section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -golang"
    sed --follow-symlinks -i -e "s/golang        # Go section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    #echo "-php"
    #sed --follow-symlinks -i -e "s/php           # PHP section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -rust"
    sed --follow-symlinks -i -e "s/rust          # Rust section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -haskell"
    sed --follow-symlinks -i -e "s/haskell       # Haskell Stack section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -julia"
    sed --follow-symlinks -i -e "s/julia         # Julia section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -aws"
    sed --follow-symlinks -i -e "s/aws           # Amazon Web Services section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -venv"
    sed --follow-symlinks -i -e "s/venv          # virtualenv section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -conda"
    sed --follow-symlinks -i -e "s/conda         # conda virtualenv section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -dotnet"
    sed --follow-symlinks -i -e "s/dotnet        # .NET section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -ember"
    sed --follow-symlinks -i -e "s/ember         # Ember.js section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -kubecontext"
    sed --follow-symlinks -i -e "s/kubecontext   # Kubectl context section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    echo "  -terraform"
    sed --follow-symlinks -i -e "s/terraform     # Terraform workspace section/ /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    #sed --follow-symlinks -i -e "s// /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    #sed --follow-symlinks -i -e "s// /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
    #sed --follow-symlinks -i -e "s// /g" $HOME/.zsh/themes/spaceship-prompt/spaceship.zsh
else
    if [ ! -L "$HOME/.zsh/themes/powerlevel10k.zsh-theme" ]; then
        echo "Cloning and symlinking powerlevel10k"
        git clone https://github.com/romkatv/powerlevel10k.git $HOME/.zsh/themes/powerlevel10k
        ln -s "$HOME/.zsh/themes/powerlevel10k/powerlevel10k.zsh-theme" "$HOME/.zsh/themes/powerlevel10k.zsh-theme"
    else
        echo "Updating powerlevel10k"
        git -C $HOME/.zsh/themes/powerlevel10k pull
    fi
fi

echo "Done"
