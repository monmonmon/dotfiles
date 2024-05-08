#!/usr/bin/env bash

i=1
for f in $(ls -tr); do
    if [ ! -f "$f" ]; then
        continue
    fi
    num=$(printf "%03d" $i)
    ext="${f##*.}"
    g="$num.$ext"
    if [ "$f" != "$g" ]; then
        echo mv "$f" "$g"
        mv "$f" "$g"
    fi
    i=$(($i + 1))
done
