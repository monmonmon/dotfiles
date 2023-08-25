#!/bin/sh

if [ $# -ne 1 ]; then
    echo "ディレクトリ以下のファイルの最終更新時刻を名前順に更新"
    echo "Usage: $(basename $0) <directory>"
    exit 1
fi

dir="$1"
if [ ! -d "$dir" ]; then
    echo "No such directory: $dir"
    exit 1
fi

cd "$dir"
basetime=$(stat -f '%m' "$(ls | head -1)")

i=0
for f in $(ls); do
    time=$(date -r $(($basetime + $i)) +"%Y%m%d%H%M.%S")
    echo $time $f
    touch -t $time "$f"
    i=$(($i + 1))
done
