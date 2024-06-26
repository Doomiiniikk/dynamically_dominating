#! /usr/bin/bash

wallpaper_d=~/.config/wallpapers
latest=$wallpaper_d/latest.jpg # the current wallpaper
old=$wallpaper_d/old.jpg # the previous wallpaper


make_wallpaper () {

    if [ ! $1 ] ; then 
        return 1 
    fi

    if [[ -d $1 ]] ; then

        echo "Wallpaper directory exists"
        return 0

    elif [[ -f $1 ]] ; then 

        echo "Given parameter is a file, not a directory"
        mv $1 "$1_FILE" && echo "Moved given parameter to '$1_FILE'"

    else 

        echo "Directory doesn't exist"
    fi

    if mkdir $1 &> /dev/null ; then
        echo "Created the directory"
    else
        echo "Failed to create the directory"
        exit 1
    fi

    return 0
}



f_add () {
    
    if ( [ ! $1 ] || [ ! -f $1 ] ) ; then
        echo "No valid file given!"
        return 1
    fi

    local filePath=$(realpath $1) # the file to be added

    if [[ -f $latest ]] ; then
        echo "backing up the current wallpaper"
        mv $latest $old
    fi
    echo $filePath 
    echo $latest
    if cp $filePath $latest &> /dev/null ; then
        echo "Successfully installed the wallpaper"
        feh --bg-scale $latest
    else
        echo "Failed to install the wallpaper"
        return 1
    fi

    return 0
}

f_switch () {
    
    if [[ -f $latest && -f $old ]] ; then

        local latest_temp="${latest}TEMP"
        if mv $latest $latest_temp  && mv $old $latest && mv $latest_temp $old ; then
            echo "Successfully switched the old and latest wallpapers"
        else
            echo "Failed"
            exit 1
        fi
        return 0
    else
        echo "There are not enough files to switch the wallpaper"
        echo "Please run again with argument:"
        echo "    add /path/to/picture"
    fi
}


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

case "$1" in

    "add")
        f_add "$2"
    ;;
    "switch")
        f_switch
    ;;
    *)
        echo "That is not an option"
        exit 1
    ;;
esac

