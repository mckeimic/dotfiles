#!/bin/bash

mkdir -p ~/.config/wallpapers

the_date=$(date -d 'yesterday' '+%Y_%m_%d_%j')
wget -O ~/.config/wallpapers/modis.jpg "http://ge.ssec.wisc.edu/modis-today/index.php?satellite=t1&product=true_color&date=$the_date&overlay_sector=false&overlay_state=true&overlay_coastline=true&sector=USA1&resolution=250m"

