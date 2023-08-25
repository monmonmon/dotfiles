#!/bin/bash
# ホストスキャナ
# fping でおｋ

# arping command is required
if ! which arping 2>&1 > /dev/null; then
    echo arping is not installed
    exit 1
fi

# check argument
interface=$1
if [ -z "$interface" ]; then
    echo "Usage: $(basename $0) <interface>"
    exit 1
fi

trap "exit 1"        HUP INT PIPE QUIT TERM

ip=$(ipconfig getifaddr $interface)
subnet=$(echo $ip | cut -d. -f3)
list=()
for host in {0..255}; do
    ipaddr="192.168.${subnet}.${host}"
    #echo "[*] IP : ${ipaddr}"
    arping -c1 -w100000 -i $interface $ipaddr &>/dev/null
    if [ $? -eq 0 ]; then
        echo "found: ${ipaddr}"
        list=(${list[@]} $ipaddr)
    fi
done
