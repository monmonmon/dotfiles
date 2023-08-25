#!/bin/sh

if [ $# -eq 0 ]; then
    echo "第1引数で渡されたファイルの最終更新時刻で、第2引数以降の全てのファイルの最終更新時刻を更新する"
    echo "Usage: $(basename $0) file [file ...]"
    exit
fi

echo "$(($#)) files"
first="$1"
echo "$first"
shift

while [ -n "$1" ]; do
    test -r "$1" || continue
    echo "$1"
    touch -r "$first" "$1"
    shift
done
