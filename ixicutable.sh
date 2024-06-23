#! /usr/bin/bash

# for all the lazy people out there.. smh
# run "bash ixicutable.sh" to save a step chmodding :D

echo "You lazy piece! But hey, since you run me.. I might as well do what you want :|"

for file in ./* ; do
    case $file in *.sh)
        if ! chmod u+x $file ; then 
            echo "failed to chmod $file"
        fi ;;
    esac
done

echo "Done... stupid"