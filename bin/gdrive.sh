#!/bin/bash

dir=/gdrive
if [ -n "$1" ]; then
    dir=$1
fi

if [ ! -d $dir ]; then
    echo 'no such directory:' $dir
    exit 1
elif ! which google-drive-ocamlfuse 2>&1 > /dev/null; then
    echo 'google-drive-ocamlfuse is not installed'
    exit 1
elif mount | grep -q google-drive-ocamlfuse; then
    echo 'already mounted'
    exit 1
else
    google-drive-ocamlfuse $dir
fi
