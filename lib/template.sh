#!/usr/bin/env bash
PATH=/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
set -e

if [ $# -ne 1 ]; then
    echo "Usage: $(basename $0) fname"
    exit 1
elif [ ! -f "$1" ]; then
    echo $1: No such file
    exit 1
fi

fname=$1
