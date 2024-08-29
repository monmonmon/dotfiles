#!/bin/bash
# mount Google Drive to /gdrive on Linux

dir=/gdrive
if [ -n "$1" ]; then
    dir=$1
fi

if [ ! -d "$dir" ]; then
    echo 'no such directory:' "$dir"
    exit 1
elif ! which google-drive-ocamlfuse > /dev/null 2>&1; then
    echo 'google-drive-ocamlfuse is not installed'
    exit 1
elif mount | grep -q google-drive-ocamlfuse; then
    echo 'google drive is already mounted'
    exit 1
fi

google-drive-ocamlfuse "$dir"
