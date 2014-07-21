#!/bin/bash

BACKUP_DIR="~/.backup_configs"
CONFIG_DIR="~/.mconfig/"
INSTALLER=""

function main {
    # Install the configs
    set +e
    if $DO_INSTALL
    then
        install_packages git vim zsh curl
        .
    fi
    set -e
    initialize
    configure_git
    configure_bash
    configure_vim
    configure_zsh
    configure_python
    configure_screen
    configure_tmux
    #configure_xmonad

    print_notes
    echo "Done!"
}

function backup {
    # Move each item passed as an argument into the directory, $BACKUP_DIR
    for i in $@
    do
        if [ -e "$i" ]
        then
            mv "$i" "$BACKUP_DIR/$i"
            echo "mv $BACKUP_DIR/$i $(readlink -e $i)" >> "$BACKUP_DIR/uninstall.sh"
        fi
    done
}

function initialize {
    mkdir -p "$BACKUP_DIR"
    rm "BACKUP_DIR/uninstall.sh"
}

function configure_git {
backup ~/.gitconfig
ln -s "$CONFIG_DIR/configs/git/gitconfig" ~/.gitconfig
}

function configure_bash {
backup ~/.bashrc
ln -s "$CONFIG_DIR/configs/bash/bashrc" ~/.bashrc
touch ~/.bashrc.local
}

function configure_vim {
backup ~/.vimrc ~/.vim
ln -s "$CONFIG_DIR/configs/vim/vimrc" ~/.vimrc
ln -s "$CONFIG_DIR/configs/vim/vim" ~/.vim
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
}

function configure_zsh {
backup ~/.zshrc ~/.zshenv
curl -L http://install.ohmyz.sh | sh
ln -s "$CONFIG_DIR/configs/zsh/zshrc" "~/.zshrc"
ln -s "$CONFIG_DIR/configs/zsh/zshenv" "~/.zshenv"
}

function configure_python {
backup ~/.pythonrc
ln -s "$CONFIG_DIR/configs/python/pythonrc"
}

function configure_screen {
backup ~/.screenrc
ln -s "$CONFIG_DIR/configs/screen/screenrc"
}

function configure_tmux {
backup ~/.tmux.conf
ln -s "$CONFIG_DIR/configs/tmux/tmux.conf" ~/.tmux.conf
}

function configure_xmonad {
backup ~/.xmonad
sudo apt-get install xmonad dzen2 suckless-tools
ln -s "$CONFIG_DIR/xmonad" ~/.xmonad
}

function print_notes {
echo
echo "Terminator and xterm configs are living in $CONFIG_DIR/configs/"
echo "wire them up with ln -s if you need"
echo
echo "To setup gnome-terminal with solarized:"
echo "    sudo apt-get install dconf-cli"
echo "    git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git"
echo
echo "To install xmonad configs, uncomment those lines in this script, or run:"
echo "   sudo apt-get install xmonad dzen2 suckless-tools"
echo "   ln -s "$CONFIG_DIR/xmonad" ~/.xmonad"
echo
echo "To remove these new configs and restore existing ones, run:"
echo "    bash $BACKUP_DIR/uninstall.sh"
echo
echo "Mark any issues with github.com/mckeimic/mconfig"
echo
}

function install_packages {
    # Install each argument with whatever package manager is available
    PACKAGES=$@
    if [ $(command -v brew) ]
    then
        INSTALLER="brew"
        PACKAGES="$PACKAGES mvim"
    elif [ $(command -v apt-get)  ]
    then
        INSTALLER="apt-get"
    elif [ $(command -v yum) ]
    then
        INSTALLER="yum"
    else
        echo "Couldn't determine package manager." 1>&2
        echo "Please install $PACKAGES on your own, and run this script again with --no-install" 1>&2
        exit 1
    fi
    echo "Guessing your sustem used $INSTALLER to install packages?"
    echo
    for i in $PACKAGES
    do
        echo "Attempting to install $i"
        $INSTALLER install "$i"
    done
}

##############################################################################
#####################     Parse Arguments       ##############################
##############################################################################
#Set default options
DO_INSTALL=true

# Parse options
while [ $# -gt 0 ]
do
    key="$1"
    shift

    case $key in
        --no-install)
            DO_INSTALL=false
            echo "Will not attempt to install packages for you."
            shift
            ;;
        *)
            echo "Unknown option $key"
            exit 1
            ;;
esac
done

main
