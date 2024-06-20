#! /usr/bin/bash

wallpaper_d=~/.config/wallpapers
latest=$wallpaper_d/latest.jpg # the current wallpaper
old=$wallpaper_d/old.jpg # the previous wallpaper

# variable overrides
# wallpaper_d=test


if [[ ! -d $wallpaper_d ]] ; then
    echo "Wallpaper directory doesn't exist.. repairing!"
    while true; do
        if ! mkdir $wallpaper_d &> /dev/null ; then
            if [[ -f $wallpaper_d ]] ; then
                echo "Can't create wallpaper directory because it is a file.. fixing"
                mv $wallpaper_d "${wallpaper_d}_FILE"
            fi
        else
            echo "Created wallpaper directory"
            break
        fi
    done
fi


if [[ $1 ]] ; then
    
    if [[ "$1" == "add" ]] ; then
        if [[ ( ! "$2" ) && ( ! -f "$2" ) ]]; then
            echo "No valid file given"
            exit
        fi
        picPath=$(realpath $2)
    
        if [[ -f $latest ]] ; then
            echo "backing up the current wallpaper"
            mv $latest $old
        fi
        
        if cp $picPath $latest &> /dev/null ; then
            echo "Successfully installed the wallpaper"
            feh --bg-scale $latest
        else
            echo "Failed to install the wallpaper"
            exit
        fi



    fi
else
    echo "no option was entered, please enter one of the following"
    echo "add"

fi

