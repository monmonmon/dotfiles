#!/bin/bash
PATH=/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

if [ $# -ne 1 ]; then
    echo "Usage: $(basename $0) <dirname>"
    exit 1
elif [ ! -d "$1" ]; then
    echo $1: No such directory
    exit 1
fi

dname=$1

i=1
for d in "$dname"/*; do
    echo $d
    test -d "$d" || continue
    for f in "$d"/*.jpg; do
        g=$(printf "%03d.jpg" $i)
        cp "$f" "$dname"/"$g"
        i=$(($i + 1))
    done
done
