#!/bin/bash
PATH=/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
set -e

if [ $# -eq 0 ]; then
    echo "find vendor names from mac addresses"
    echo "Usage: $(basename $0) <macaddr>..."
    exit 1
fi

url=https://macvendors.com/query

while [ -n "$1" ]; do
    mac=$1
    if echo $mac | grep '^\([0-9a-f]\{2\}[:-]\?\)\{5\}[0-9a-f]\{2\}$' 2>&1 > /dev/null; then
        addr=$(echo $mac | sed 's/[:-]//g')
        query="$url/$addr"
        vendor=$(curl -s $query)
        if echo $vendor | grep DOCTYPE 2>&1 > /dev/null; then
            # seems to have requested too many
            echo $vendor
            echo "Quitting..."
            break
        fi
        echo "$mac $vendor"
        sleep 1
    else
        echo "* SKIP $mac"
    fi
    shift
done
