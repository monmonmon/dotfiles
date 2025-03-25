#!/bin/bash

if [ -d /mnt/hgfs/irodori-pki ]; then
    exit
fi
sudo vmhgfs-fuse .host:/ /mnt/hgfs -o allow_other,uid=`id -u`
