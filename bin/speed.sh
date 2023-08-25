#!/bin/bash

TMPFILE=/tmp/wget.log
wget -O /dev/null -a $TMPFILE -t 3 -T 20 http://www.asahi-net.or.jp/~yh8n-wke/image/speed_imagec1.jpg
wget -O /dev/null -a $TMPFILE -t 3 -T 20 http://homepage3.nifty.com/bnr/image/speed_imagec1.jpg
wget -O /dev/null -a $TMPFILE -t 3 -T 20 http://bnr.on.arena.ne.jp/image/speed_imagec1.jpg
wget -O /dev/null -a $TMPFILE -t 3 -T 20 http://www5d.biglobe.ne.jp/~adsl/image/speed_imagec1.jpg
grep -w saved $TMPFILE
rm $TMPFILE
