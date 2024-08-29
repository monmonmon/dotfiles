#!/bin/zsh
# カレントディレクトリの幅 1080px を超える画像を幅 1080px にリサイズする

while getopts "dh" opt; do
    case $opt in
        d)  # dryrun
            dryrun=1
            ;;
        *)  # help
            echo "Usage: $(basename "$0") [-d] [-h]" >&2
            exit
            ;;
    esac
done
shift $((OPTIND - 1))

size=1200
for f in *; do
    if file -b --mime-type "$f" | cut -d/ -f1 | grep -vq image; then
        continue
    fi
    w=$(identify -format %w "$f")
    if [ "$w" -gt "$size" ]; then
        echo "$f"
        test -n "$dryrun" && continue
        g="1.$f"
        convert -thumbnail "${size}x${size}" "$f" "$g"
        touch -r "$f" "$g"
        mv "$g" "$f"
    fi
done
