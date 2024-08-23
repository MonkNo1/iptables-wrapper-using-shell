#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
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
