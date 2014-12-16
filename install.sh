#!/bin/bash

set -e
set -u

ANSIBLEDIR=/tmp/ansible-mconfig

function main {
    case "$1" in
        osx)
            osx
            ;;
        ubuntu)
            ubuntu
            ;;
        *)
            echo "Please pass either 'osx' or 'ubuntu' in as the first argument"
    esac

    setup
}

function ubuntu {
    sudo apt-get install ansible
}

function osx {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install ansible
}

function setup {
    trap "{ rm -f $ANSIBLEDIR ; exit 255; }" EXIT
    git clone https://github.com/mckeimic/Ansible.git $ANSIBLEDIR
    ansible-playbook $ANSIBLEDIR/personalize.yml --ask-sudo-pass
}

main $@
exit 0
