#!/bin/bash

PATH=/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

if [ $# -ne 1 ]; then
    echo "Usage: $(basename $0) <disk>"
    exit 1;
elif [ ! -b "$1" ]; then
    echo $1: is not a block special file
    exit 1;
fi
tmpfile=$1

#for bs in 16m 32m 64m 128m 256m 512m; do
for bs in 1m 2m 4m 8m 16m 32m; do
    echo "---------------------------------------"
    echo "Testing block size = $bs"
    sudo dd if=/dev/zero of=$tmpfile count=100 bs=$bs
    echo
done
