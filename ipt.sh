#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Default policies
DEFAULT_POLICY="DROP"
LOOPBACK_POLICY="ACCEPT"

echo "Avilable Devices : $dev"
ifconfig -a | sed 's/:$//' | awk '/^[a-zA-Z]/ { iface=$1 } /inet / { print "* " iface ": " $2 }'

read -p "Enter The WAN interface name : " interface

# Flush iptables rules
sudo iptables -F

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

# Optionally, ask user if they want to handle traffic from a specific IP
handle_ip_traffic() {
    echo -e "${YELLOW}Handle traffic from a specific IP:${NC}"
    read -p "Do you want to allow any specific IP ? (y/n): " allow_specific_ip
    if [ "$allow_specific_ip" == "y" ] || [ "$allow_specific_ip" == "Y" ]; then
        while [ true ]; do
            read -p "Enter the IP address: " specific_ip
            read -p "Do you want to accept or drop traffic from this IP? (ACCEPT/DROP): " specific_ip_action
            read -p "Protocol of service : (tcp/udp): " sproto

            sudo iptables -A INPUT -s "$specific_ip" -j "$specific_ip_action"
            sudo iptables -A OUTPUT -d "$specific_ip" -j "$specific_ip_action"

            echo "Rules added $sproto/$specific_ip => $specific_ip_action "
            read -p "Do you want to add Another IP (y/n): " op
            if [[ "$op" == "n" || "$op" == "N" ]]; then
                break
            fi
        done
    fi
}

# Set default policies
sudo iptables -P OUTPUT ACCEPT
# iptables -A INPUT -i lo -j $LOOPBACK_POLICY

handle_services() {
    # Ask user for connection types and ports to allow
    echo -e "${YELLOW}Specify connection types:${NC}"
    read -p "Do you want to allow any specific Service  ? (y/n): " allow_specific_Ser
    if [ "$allow_specific_Ser" == "y" ] || [ "$allow_specific_Ser" == "Y" ]; then
        while [ true ]; do
            read -p "TCP/UDP/ALL: " proto
            echo -e "${YELLOW}Specify ports or port ranges to allow:${NC}"
            read -p "Port (e.g., 80) or port range (e.g., 22-80): " port_input
            read -p "Do you want to accept or drop traffic ? (ACCEPT/DROP) : " action

            sudo iptables -A INPUT -p "$proto" --dport "$port_input" -j "$action"

            echo "Rules added $proto/$port_input => $action "
            read -p "Do you want to add Another service (y/n): " op
            if [[ "$op" == "n" || "$op" == "N" ]]; then
                break
            fi
        done
    fi
}

handle_ip_traffic
handle_services

sudo iptables -L -v -n
sudo iptables -F

echo "Flusing all the Rules....!"
