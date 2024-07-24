#!/bin/bash
set -e

ssh_user=ymdsmn

port_check() {
    netstat -an|grep LISTEN|grep "127.0.0.1.${1}"|wc -l
}

is_using_port_45522=$(port_check 45522)
if [ $is_using_port_45522 -eq 0 ]; then
    ssh -N -f -L 45522:10.2.110.55:22 ${ssh_user}@59.158.57.249
fi

is_using_port_48080=$(port_check 48080)
if [ $is_using_port_48080 -ne 0 ]; then
	echo 'Port 48080 is already used' >&2
	echo 'Perhaps already socks proxy is working' >&2
	exit 1
fi

ssh -oHostKeyAlias=10.2.110.55 ${ssh_user}@127.0.0.1 -p45522 -D 48080 -N -f
