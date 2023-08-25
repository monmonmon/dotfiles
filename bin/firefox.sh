#!/bin/sh
set -e

#dir=/Users/monmon/Library/Caches/Firefox/Profiles/yn6am8mi.default/Cache
dir=FFCache/

#files=($(find $dir -type f | xargs ls -lS | grep -v -e '_CACHE_' | head -30 | awk '{print $9}'))
#ls -lS ${files[@]} | awk '{print $6,$7,$8,$9}'
#file ${files[@]}

files="$(find $dir -type f)"
#movie_files=$(file ${files[@]} | grep -e 'MPEG' -e 'Macromedia Flash data' | cut -d: -f1)
movie_files=$(file ${files[@]} | awk -F: '/MPEG/{print $1} /Macromedia Flash Video/{print $1}')
if [ -n "$movie_files" ]; then
	ls -lt $movie_files
fi
