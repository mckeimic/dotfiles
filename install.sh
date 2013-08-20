#!/bin/bash

set -e # If anything returns a non-true value, everything dies before snowballing.
set -u # Any attempted use of unitialized variables shall result in death.

install_dir=".mconfig"
backup_dir="$install_dir/backups"

echo 'Welcome!'
echo 'The capitalized letter in each prompt is the default'
echo 'Press enter for the default answer or specify manually'
echo
echo 'All of your old configuration files will be backed up in ~/.mconfig/backup'

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

get_it()
{
    trap 'rm -rf "$install_dir/"; exit' INT TERM # Attempts to delte the install directory if anything dies half way
    # Asks whether to download everything with curl or using git
    if ask_about "Clone from Github?" Y; then
        if ask_about "Use SSH? (Your public key must be registered with Github)" Y; then
            git clone git@github.com:mckeimic/mconfig.git "$install_dir/"
        else
            git clone https://github.com/mckeimic/mconfig.git "$install_dir/"
        fi
    else
        echo "Pulling down the latest version with curl..."
        mkdir -p /tmp/mconfig

        trap 'rm -rf /tmp/mconfig/; exit' INT TERM 
        cd /tmp/mconfig
        curl -sS "http://mckeimic.com/mconfig/mconfig.zip" > /tmp/mconfig/mconfig.zip
        unzip /tmp/mconfig/mconfig.zip
        rm -rf /tmp/mconfig/mconfig.zip
        mv/tmp/mconfig/mconfig "$install_dir/"
        trap - INT TERM 

    fi
    mkdir -p "$install_dir/backup"

    trap - INT TERM 
}

configure()
{
    # Vim
    if ask_about "Configure Vim? (No for portable Vim or if you don't have Git)" Y; then
        configure_vim;
    else
        if ask_about "Configure portable Vim? (If you don't have Git, or want this to be lightweight)" Y; then
            configure_portable_vim
        fi
    fi

    # Tmux
    if ask_about "Configure Tmux?" Y; then
        configure_tmux
    fi

    # SSH
    if ask_about "Configur SSH?" Y; then
        configure_ssh
    fi

    # Git
    if ask_about "Configure Git?" Y; then
        configure_git
    fi

    # Xmonad
    if ask_about "Configure Xmonad?" Y; then
        configure_xmonad
    fi

    # Bash
    if ask_about "Configure Bash?" Y; then
        configure_bash
    fi

    # Zsh
    if ask_about "Configure Zsh (and change shell?)" Y; then
        configure_zsh
    fi

    # Gnome-Terminal
    if ask_about "Setup Gnome-Terminal?" Y; then
        configure_gnome_terminal
    fi

    # iTerm2
    if ask_about "Setup iTerm2?" Y; then
        configure_iterm2
    fi

    # Terminator
    if ask_about "Setup Gnome-Terminal?" Y; then
        configure_terminator
    fi
    
}

configure_vim()
{
    # Backup old Vim things
    touch ~/.vimrrc
    cp -r ~/.vim* "$backup_dir"

    # Link to new stuff
    ln -fs "$install_dir/config/vim/vimrc" ~/.vimrc
    mkdir -p ~/.vim/bundle/
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    vim +BundleInstall +qall
}

configure_portable_vim()
{
    # Backup old Vim things
    touch ~/.vimrc
    cp -r ~/.vim* "$backup_dir"
    ln -fs "$install_dir/config/vim/vimrc" ~/.vimrc
}

configure_tmux()
{
    touch ~/.tmux.conf
    cp -r ~/.tmux* "$backup_dir"    
    ln -fs "$install_dir/config/tmux/tmux.conf" ~/.tmux.conf
}

configure_ssh()
{
    touch ~/.ssh/config
    cp ~/.ssh/config "$backup_dir/ssh/"
    cp "$install_dir/config/ssh/config" ~/.ssh/config

}

configure_git()
{
    touch ~/.gitconfig
    echo "Ok, time to set up your Git."
    cp ~/.gitconfig "$backup_dir/"
    ln -fs "$install_dir/config/git/gitconfig" ~/.gitconfig
    echo "Enter the information you'd like displayed for commits below:"
    read -p "Name: " name
    read -p "Email: " email

    git config --global user.name "$name"
    git config --global user.email "$email"
}

configure_xmonad()
{
    touch ~/.xmobarrc
    echo "Don't forget to install gmrun and xmobar later!"
    cp -r ~/.xmo* "$backup_dir/"
    ln -fs  "$install_dir/config/xmonad/xmonad/" "~/.xmonad"
    ln -fs  "$install_dir/config/xmonad/xmobarrc" "~/.xmobarrc"
}

configure_bash()
{
    touch ~/.bashrc.local
    touch ~/.bashrc
    cp ~/.bashrc* "$backup_dir/"
    ln -fs "$install_dir/config/bash/bashrc" ~/.bashrc
    ln -fs "$install_dir/assets/dir_colors" ~/.dir_colors
}

configure_zsh()
{
    touch ~/.zshrc
    touch ~/.zshrc.local
    cp ~/.zsh* "$backup_dir/"
    ln -fs "$install_dir/zsh/zshrc" ~/.zshrc
    echo "Installing Oh-my-zsh now"
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

    if ask_about "Install zsh syntax highlighting? (Requires git)" Y; then
        git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    fi
}

configure_gnome_terminal()
{
    pass;
}

configure_iterm2()
{
    pass;
}

configure_terminator()
{
    mkdir -p ~/.config/terminator

}

clean()
{
    echo "Delete/restore everything this script does"
}

update()
{
    echo "Pull down and update files using git"
}


#case "$1" in
#"install")   echo "INSTALLING";;
    #"reinstall") echo "REINSTALLING";;
#"clean")     echo "CLEANING UP";;
    #"update")    echo "UPDATING";;
#:)           echo "PRINTING USAGE";;
    #?)           echo "DONT EVEN KNOW";;
    #esac

get_it
configure
