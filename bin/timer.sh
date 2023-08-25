#!/bin/bash
# @(#)Commandline timer with notification center
# @(#)Usage: $0 [-h] <time h/m/s>
readonly SCRIPTNAME="$(basename "$0")"
export sec=0
for arg in "$@"; do
  if [[ "$arg" =~ ([0-9]+)([hms]) ]];then
    num=${BASH_REMATCH[1]}
    unit=${BASH_REMATCH[2]}
    case "$unit" in
      h)
        sec=$((sec += num * 3600))
        ;;
      m)
        sec=$((sec += num * 60))
        ;;
      s)
        sec=$((sec += num))
        ;;
    esac
  fi
done
echo "$SCRIPTNAME: After $sec sec"
sleep "$sec"
osascript -e "display notification \"$sec sec elapsed.\" with title \"$SCRIPTNAME\""
