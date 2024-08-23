#!/bin/bash

source "lib/basic.sh"
source "lib/rule_adding.sh"
source "lib/colors.sh"

# Default policies
DEFAULT_POLICY="DROP"
LOOPBACK_POLICY="ACCEPT"

interface=""

echo "Avilable Devices : "
ifconfig -a | sed 's/:$//' | awk '/^[a-zA-Z]/ { iface=$1 } /inet / { print "* " iface ": " $2 }'
while [ true ]; do
    read -p "Enter The WAN interface name : " interface
    if ip link show "$interface" >/dev/null 2>&1; then
        # echo -e "${BRIGHT_WHITE} WAN DEv s"
        echo -e "${GREEN}Selected WAN interface : $interface ${RESET}"
        break
    else
        echo -e "${RED} WRONG interface selected : $interface ${RESET}"
    fi
done

# Flush iptables rules
sudo iptables -F

# wan_dev = $(select_dev)
basic $interface
handle_ip_traffic
handle_services

sudo iptables -L -v -n
sudo iptables -F

echo -e "${CYAN}Flusing all the Rules....!"

# iptables -A INPUT -i lo -j $LOOPBACK_POLICY
