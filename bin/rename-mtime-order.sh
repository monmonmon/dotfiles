#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "指定ディレクトリ以下のファイルを更新時刻順に 001.xx, 002.xx, ... とリネーム"
    echo "Usage: $(basename "$0") <directory>"
    exit 1
fi

dir="$1"
if [ ! -d "$dir" ]; then
    echo "No such directory: $dir"
    exit 1
fi
cd "$dir" || exit

tmpdir=$(mktemp -d)
function cleanup {
    rmdir "$tmpdir"
}
trap cleanup EXIT

i=1
for f in $(ls -tr); do
    num=$(printf "%03d" $i)
    ext="${f##*.}"
    g="$num.$ext"
    echo "rename $f to $g"
    mv "$f" "$tmpdir/$g"
    i=$((i + 1))
done
mv "$tmpdir"/* .
