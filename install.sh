#!/bin/bash

set -e 
set -u

ask_about()
{
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the Question
        read -p "$1 [$prompt] " REPLY

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if reply is valid
        case "$REPLY" in 
            Y*|y*) return 0;;
            N*|n*) return 1;;
        esac
    done
}

echo
read -p "Hi"
echo
echo "You should install these things first if you can:"
echo "Vim, tmux, git, terminator, iTerm2, Xmonad, and Zsh"
echo "Unless they don't apply to you or you're in a god-forsaken wasteland of an OS of course"
echo
echo 
echo "If you can't do the whole git thing either, you should run this instead:"
echo "curl -sS 'http://mckeimic.com/mconfig/mconfig.zip' > temp.zip && unzip temp.zip"
echo "I also highly recommend being in your home directory right now."
if ask_about "Keep going? (Y) Or stop to do that stuff first? (N)" Y; then
    echo "Great. Enjoy."
    echo
    echo
else
    exit;
fi

if ask_about "Clone with git?" Y; then
    git clone http://github.com/mckeimic/mconfig.git .mconfig
    install_dir=".mconfig"
else
    read -p "Ok then genius, where is all my stuff? " install_dir
fi

mkdir -p "$install_dir/backup"

if ask_about "Setup Vim?" Y; then
    touch ~/.vimrc
    mv ~/.vimrc "$install_dir/backup/"
    ln -fs "$install_dir/config/vim/vimrc" ~/.vimrc
    mkdir -p ~/.vim/bundle
    vim +BundleInstall +qall
else 
    if ask_about "Do you at least want a minimal vim config?" Y;then
        echo "Someday soon."
    fi
fi

if ask_about "Setup Git?" Y; then
    touch ~/.gitconfig
    mv ~/.gitconfig "$install_dir/backup/"
    ln -fs "$install_dir/config/git/gitconfig" ~/.gitconfig
    echo "Ok. We're gonna set up Git now."
    echo "Enter the information you want to show up on your commits: "
    read -p "Name:  " name
    read -p "Email: " email
    git config --global user.name "$name" 
    git config --global user.email "$email" 
fi

if ask_about "Setup Tmux?" Y; then
    touch ~/.tmux.conf
    mv ~/.tmux.conf "$install_dir/backup/"
    ln -fs "$install_dir/config/tmux/tmux.conf" ~/.tmux.conf
fi

if ask_about "Setup Xmonad?" N; then
    touch ~/.xmobarrc
    mkdir -p ~/.xmonad
    mv "~/.xmonad" "$install_dir/backup/"
    mv "~/.xmobarrc" "$install_dir/backup/"
    ln -fs "$install_dir/config/xmonad/xmonad/" ~/.xmonad/
    ln -fs "$install_dir/config/xmonad/xmobarrc" ~/.xmobarrc
fi

if ask_about "Setup Bash?" Y; then
    touch ~/.bashrc
    touch ~/.bashrc.local
    mv ~/.bashrc "$install_dir/backup/"
    cp "$install_dir/assets/dir_colors" ~/.dir_colors
    ln -fs "$install_dir/config/bash/bashrc" ~/.bashrc
fi

if ask_about "Setup Zsh?" Y; then
    sudo curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
    if ask_about "Install Zsh Syntax highlighting? (Requires git)" Y; then
        git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    fi
    touch ~/.zshrc
    touch ~/.zshrc.local
    mv ~/.zshrc "$install_dir/backup/"
    cp "$install_dir/assets/dir_colors" ~/.dir_colors
    ln -fs "$install_dir/config/zsh/zshrc" ~/.zshrc
fi

if ask_about "Setup Terminator?" Y; then
    mkdir -p ~/.config/terminator
    mkdir -p "$install_dir/backup/.config/terminator"
    touch ~/.config/terminator/config
    mv ~/.config/terminator/config "$install_dir/backup/.config/terminator/"
    ln -fs "$install_dir/config/terminator/config" ~/.config/terminator/config
fi

if ask_about "Setup Gnome-Terminal? (Requires Git)" N;then
    git clone https://github.com/sigurdga/gnome-terminal-colors-solarized /tmp/colors 
    /tmp/colors/install.sh
    rm -rf /tmp/colors
fi

echo "Well, thats about it for now."
