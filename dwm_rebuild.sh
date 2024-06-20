#!/usr/bin/bash

sless_dir=$(dirname -- $(realpath -- ${BASH_SOURCE[0]}))
dwm_dir="$sless_dir/dwm"

if cd $dwm_dir > &> /dev/null ; then
	echo "moved to $dwm_dir"
else
	echo "Failed to move... \nexiting"
	exit
fi

preConf_h="$dwm_dir/config.def.h"
conf_h="$dwm_dir/config.h"

if [[ -f $conf_h ]] ; then
	echo "backing up $conf_h"
	cp $conf_h "$conf_h.bak"
	clear
	#echo "\033[1;1f\x1b[2J"
	echo "Your config is backed up. Consider backing it up again, just in case."
	echo "It will be overwritten in the next run!"
	sleep 5
fi
	


if [[ -f $preConf_h ]] ; then
	if ! cp $preConf_h $conf_h &> /dev/null ; then
		echo "Failed to copy config"
	else
		echo "Successfully copied config"
	fi
fi

if sudo make clean install ; then
	echo "Successfully built dwm"
else
	echo "failed to build dwm... \nexiting"
	exit
fi

dwm_bin="$dwm_dir/dwm"
usrbin="/usr/local/bin"
usrbin_dwm="/usr/local/bin/dwm" 

if [[ -f $dwm_bin ]] ; then
	echo "Installing dwm"
	if sudo cp $dwm_bin $usrbin_dwm &> /dev/null ; then
		echo "Installed binary to $usrbin"
	else
		echo "failed to install dwm... \nexiting"
		exit
	fi
fi

dwm_desktop="dwm.desktop"
local_dwm_desktop="$dwm_dir/$dwm_desktop"
usrxsess="/usr/share/xsessions"
usrxsess_dwm="/usr/share/xsessions/$dwm_desktop"

if [[ -f $dwm_bin ]] ; then

	echo """[Desktop Entry]
 Encoding=UTF-8
 Name=Dwm
 Comment=Dynamic window manager
 Exec=dwm
 Icon=dwm
 Type=XSession""" >> $local_dwm_desktop

	if sudo cp $local_dwm_desktop $usrxsess_dwm &> /dev/null ; then
		echo "Installed desktop file $usrxsess"
	else
		echo "Failed to install desktop file... \nexiting"
		exit
	fi
	
fi
	
clear

echo "Installed dwm successfully.. I think :)"
echo "Restart dwm to apply your changes"

