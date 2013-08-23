#!/bin/bash

echo "Pick your install."
echo
echo
echo "1.) Full install (requires git)"
echo "2.) Minimal install (requires nothing)"
echo
echo
read -p "Option? " option

case "$option" in
1)    echo "Beginning...."
      cd
      git clone https://github.com/mckeimic/mconfig .mconfig
      ./.mconfig/full_install.sh
      ;;
2)    echo "Minimal Install"
      echo "Curl-ing files down....."
      curl -L -o mconfig.zip http://github.com/mckeimic/mconfig/zipball/master/
      unzip -d .mconfig mconfig.zip
      rm -rf mconfig.zip
esac

echo "Enjoy!"

