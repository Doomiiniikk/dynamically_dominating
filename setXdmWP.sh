#! /usr/bin/bash
# Script should refuse ro run as anything other than root
if (( $EUID != 0 )) ; then
    if [[ -t 1 ]] ; then
        echo "Script will try to automatically run as root"
        if ! sudo "./$0" "$@" ; then
            echo "The script failed"
            exit 1
        fi
    else
        echo "Could not request permission elevation"
        exit 1
    fi

    exit
else
    echo "running $0 as admin"
fi

xdm_d="/etc/X11/xdm/"
wallpaper_d="$xdm_d/wallpapers"
latest="$wallpaper_d/latest.jpg"
old="$wallpaper_d/old.jpg"

opList=("add")


if [[ ! -d $wallpaper_d && $wallpaper_d != $xdm_d ]] ; then 
    mkdir $wallpaper_d && echo "Created wallpaper directory"
fi

valid=false

for oper in $opList; do
    if [ "$1" == "$oper" ] ; then
        valid=true
        break
    fi
done

if [ ! $valid ]; then
    echo "No valid operation was requested... exiting..."
    echo "Please enter an operation from below:"
    echo "${opList[@]}"
    exit 1
fi

if ( [ ! "$2" ] || [ ! -f "$2" ] ) ; then
    echo "No valid file given"
    exit 1
fi

if [[ -f $latest ]] ; then
    echo "backing up current wallpaper"
    mv -f $latest $old
fi

cp "$2" $latest  && echo "Success!!!"





