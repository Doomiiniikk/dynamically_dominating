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
        # feh --bg-scale $latest # DISABLED IN XDM WALLPAP
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

exit

if [[ ! -d $wallpaper_d && $wallpaper_d != $xdm_d ]] ; then 
    mkdir $wallpaper_d && echo "Created wallpaper directory"
fi


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





