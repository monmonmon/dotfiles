#!/usr/bin/env bash
PATH=/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

debug() {
    if [ -n "$DEBUG" ]; then
        echo $*
    fi
}

usage_and_exit() {
    cmd=$(basename $0)
    echo "${cmd}: Scan local network and list their ip addresses, mac addresses and inffered vendor names"
    echo "Usage: ${cmd} <interface name>"
    exit 1
}

# get interface name from the command line argument
interface=$1
if [ -z "$interface" ]; then
    usage_and_exit
fi

# get ip address of the interface
ip_address_of_mine=$(ipconfig getifaddr $interface)
if [ -z "$ip_address_of_mine" ]; then
    echo "No such interface: $interface"
    usage_and_exit
fi
debug "ip address of the host: $ip_address_of_mine"

# get ip address of the router
ip_address_of_router=$(ipconfig getoption en0 router)
debug "ip address of the router: $ip_address_of_router"

# get network address
address1=$(echo $ip_address_of_mine | cut -d. -f1,2,3).1
address2=$(echo $ip_address_of_mine | cut -d. -f1,2,3).254
debug "addresses to scan: $address1 - $address2"

# scan hosts within the network and get a list of ip addresses
echo "scanning the local network..."
ip_addresses=($(fping -ag $address1 $address2))
echo
debug "ip addresses: $ip_addresses[@]"

# get a list of ip addresses and corresponding mac addresses using arp
ip_and_mac_list=($(arp -al -i $interface | grep -v -e incomplete | awk '/^192.168/ { print $1, $2 }'))

# create an assoc list of ip addresses -> mac addresses
#   1. initialize the map
declare -A ip_to_mac_assoc
for ip_address in ${ip_addresses[@]}; do
    ip_to_mac_assoc[$ip_address]=1
done
#   2. associate ip addresses and mac addresses
for (( i = 0; i < ${#ip_and_mac_list[@]}; i += 2 )) {
    ip_address=${ip_and_mac_list[$i]}
    mac_address=${ip_and_mac_list[$(($i + 1))]}
    if [ -z "${ip_to_mac_assoc[$ip_address]}" ]; then
        # the $ip_address does not currently exist in the network
        continue
    fi
    debug "ip_address=$ip_address -> mac_address=$mac_address"
    # foramt the mac address
    mac_address=$(echo "0x${mac_address}" | sed 's/:/ 0x/g' | xargs printf "%02x:%02x:%02x:%02x:%02x:%02x\n")
    ip_to_mac_assoc[$ip_address]=$mac_address
}

# query macvendors.com the vendor name of the mac addresses
url=https://macvendors.com/query
for ip_address in ${!ip_to_mac_assoc[@]}; do
    mac_address=${ip_to_mac_assoc[$ip_address]}
    if [ $ip_address = $ip_address_of_mine ]; then
        echo "$ip_address (you)"
    elif [ $ip_address = $ip_address_of_router ]; then
        echo "$ip_address (router)"
    elif [ $mac_address != 1 ]; then
        _mac_address=$(echo $mac_address | tr -d :)
        query="$url/$_mac_address"
        # debug "querying $query"
        vendor=$(curl -s $query)
        if echo $vendor | grep DOCTYPE 2>&1 > /dev/null; then
            # seems to have requested too many
            echo $vendor
            echo "Quitting..."
            break
        fi
        echo "$ip_address $mac_address $vendor"
        sleep 1
    else
        echo "$ip_address <no mac address> <no vendor>"
    fi
done
