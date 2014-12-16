#mConfig#

If you're lazy and trusting

## How the configuration is set up
After a couple years of having this, I decided I hate shell scripts. On the
upside, I love Ansible. So I wrote an Ansible role to setup these configs. Yay.

Long story short, to set this up you need to apply the "personalized" role from here: https://github.com/mckeimic/Ansible.git

That can be done by...

## Installation ##
### The script-ey way ###
For Ubuntu/Debian: `bash <(curl -s https://raw.github.com/mckeimic/mconfig/master/install.sh) ubuntu`

For OS X: `bash <(curl -s https://raw.github.com/mckeimic/mconfig/master/install.sh) osx`

NOTE: The OS X installer will try to install homebrew for you first!

### The Manual Way ####
. Install python and ansible (that's just `sudo apt-get install ansible python`  or `brew install ansible` respectively)
. `git clone https://github.com/mckeimic/Ansible.git`
. `ansible-playbook personalize.yml --ask-sudo-pass`  (or `ansible-playbook personalize_remote.yml -k --ask-sudo-pass` as the case may be)
