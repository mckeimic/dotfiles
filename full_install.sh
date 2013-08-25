#!/bin/bash

echo "Installing Vim things..."
ln -ins ~/.mconfig/config/vim/vimrc ~/.vimrc
mkdir -p ~/.vim/plugins
mkdir -p ~/.vim/bundle
cd ~/.vim/bundle
git clone git://github.com/altercation/vim-colors-solarized.git
mv vim-colors-solarized ~/.vim/bundle/
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
cd
vim +BundleInstall +qall

echo "Linking tmux things..."
ln -ins ~/.mconfig/config/tmux/tmux.conf ~/.tmux.conf

echo "Installing Zsh things..."
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
chsh -s $(which zsh)
ln -ins ~/.mconfig/config/zsh/zshrc ~/.zshrc
ln -is ~/.mconfig/config/zsh/zshenv ~/.zshenv
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
touch ~/.bashrc.local

echo "Linking xmonad things..."
ln -ins ~/.mconfig/config/xmonad/ ~/.xmonad

echo "Configuring git. Use the information you want to show up in commits"
read -p "Name: " name
read -p "Email: " email
git config --global user.name "$name"
git config --global user.email "$email"

echo "Linking pythonrc and configuring dir_colors..."
ln -is ~/.mconfig/config/python/pythonrc ~/.pythonrc
ln -is ~/.mconfig/assets/dir_colors ~/.dir_colors

echo "Configuring bash things..."
ln -is ~/.mconfig/config/bash/bashrc ~/.bashrc
touch ~/.bashrc.local

echo 'Further configuration info can be found in .mconfig/assets/further_configuration.md'
