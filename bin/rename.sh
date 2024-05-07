#!/usr/bin/env bash

echo $#
if [ $# -eq 0 ]; then
    echo "Usage: ${basename $0} <files to rename>"
    exit
fi
# test -n "$1" -a -d "$1" || exit 1

cd "$1"
i=1
for f in $(ls -tr); do
#for f in $(ls); do
    j=$(printf "%03d" $i)
    echo mv $f $j.jpg
    mv $f $j.jpg
    i=$(($i + 1))
done
