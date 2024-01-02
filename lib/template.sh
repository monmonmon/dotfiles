#!/usr/bin/env bash
PATH=/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
set -euxCo pipefail
cd "$(dirname "$0")"

function usage() {
    echo "Usage: $(basename "$0")"
    exit 0
}

# if [ $# -ne 1 ]; then
#     echo "Usage: $(basename $0) fname"
#     exit 1
# elif [ ! -f "$1" ]; then
#     echo $1: No such file
#     exit 1
# fi
# fname=$1

while getopts "t:h" opt; do
    case $opt in
        t)  # tag
            test -z "$OPTARG" && exit 1;
            tag=$OPTARG
            ;;
        h | *)
            usage
            ;;
    esac
done
shift $(($OPTIND - 1))
