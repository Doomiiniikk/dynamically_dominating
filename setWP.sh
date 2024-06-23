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
infoTXT="""Information:
If you want to manually change the wallpaper, either add this to ~/.xsession

\"while true; do; feh --bg-color ~/.config/wallpapers/latest.jpg ; done &\"

When you have this added, you can manually change the picture, 
    by moving it to ~/.config/wallpapers/latest.jpg
    or run this script with arguments 'add rel/path/to/picture.jpg'
"""

infoWP=$wallpaper_d/info.txt
touch $infoWP &> /dev/null
echo $infoTXT > $infoWP
echo "Added information to $infoWP"

if [[ $1 ]] ; then
    
    if [[ "$1" == "add" ]] ; then

        if ( [ ! "$2" ] || [ ! -f "$2" ] ); then
            echo "No valid file given"
            exit 1
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
            exit 1
        fi
    fi
else
    echo "no option was entered, please enter one of the following"
    echo "add"
    exit 1
fi
