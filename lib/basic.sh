#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

basic() {
    #Routing from WAN to LAN
    sudo iptables -t nat -A POSTROUTING -o "$interface" -j MASQUERADE
    sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

    sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    sudo iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT
    echo "Rules added tcp/22 => Allow "

    # Ask user to set default policies
    # sudo iptables -A INPUT -i "$interface" -j "$default_policy_input"
    echo -e "${YELLOW}Set default input policy for loopback:${NC}"
    read -p "ACCEPT/DROP: " default_policy_input
    sudo iptables -P INPUT $default_policy_input
    sudo iptables -P FORWARD $default_policy_input
    echo -e "${YELLOW}Set loopback traffic policy:${NC}"
    read -p "ACCEPT/DROP: " loopback_policy_input
    sudo iptables -A INPUT -i lo -j "$loopback_policy_input"

    # Set default output rule
    sudo iptables -P OUTPUT ACCEPT
}
