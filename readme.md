#mConfig#

##You Should Probably Know##

Before runnning anything, there are two types of install:
  1. Full - a complete install of my environment. Everything from .vimrc to .xmonad/ is installed
  2. Minimal - a travelling installation including just a more portable version of .vimrc and tmux

The full option installs configuration for `git tmux vim xmonad python ls zsh bash` and git is **required** for the install

The minimal option has no significant requirements as it simply downloads, unzips, and later deletes itself after putting its configs in the right places. 

##Actually getting it##
Download and run install.sh. The best way is the curl option shown here. If that not available, improvise. You just need to run install.sh somewhere.

    bash <(curl -s https://raw.github.com/mckeimic/mconfig/master/install.sh)

##Updating It##

I recommend going into the installation directory (probably ~/.mconfig/) and doing a git pull; if you set it up without git though you're on your own.

