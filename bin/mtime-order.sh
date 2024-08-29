#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "指定ディレクトリ以下の各ファイルの最終更新時刻をファイル名順に更新"
    echo "Usage: $(basename "$0") <directory>"
    exit 1
fi

dir="$1"
if [ ! -d "$dir" ]; then
    echo "No such directory: $dir"
    exit 1
fi

cd "$dir" || exit
basetime=$(stat -c '%Y' "$(ls | head -1)")

i=0
for f in *; do
    time=$(date -d @$((basetime + i)) +"%Y%m%d%H%M.%S")
    echo "$time" "$f"
    touch -t "$time" "$f"
    i=$((i + 1))
done
