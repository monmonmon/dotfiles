#!/bin/bash

state=0
trap 'state=1' INT

if [ $# -gt 0 ]; then
    if [ -d "$*" ]; then
        cd "$*"
    else
        echo "No such directory: $*"
        exit 1
    fi
fi

for f in *.flv; do
    g="${f%flv}mp4"
    date +'%H:%M:%S'
    du -h "$f"
    ffmpeg -v 1 -i "$f" "$g"
    touch -r "$f" "$g"
    if [ $state -eq 1 ]; then
        rm "$g"
        echo "finishing..."
        break
    fi
    du -h "$g"
    echo
done
