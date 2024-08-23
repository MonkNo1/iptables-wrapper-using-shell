#!/bin/bash

source "lib/colors.sh"

# Optionally, ask user if they want to handle traffic from a specific IP
handle_ip_traffic() {
    echo -e "${YELLOW}Handle traffic from a specific IP: ${RESET}"
    read -p "Do you want to allow any specific IP ? (y/n): " allow_specific_ip
    if [ "$allow_specific_ip" == "y" ] || [ "$allow_specific_ip" == "Y" ]; then
        while [ true ]; do
            read -p "Enter the IP address: " specific_ip
            read -p "Do you want to accept or drop traffic from this IP? (ACCEPT/DROP): " specific_ip_action
            read -p "Protocol of service : (tcp/udp): " sproto

            sudo iptables -A INPUT -s $specific_ip -j ${specific_ip_action^^}
            sudo iptables -A OUTPUT -d "$specific_ip" -j ${specific_ip_action^^}

            echo "Rules added $sproto/$specific_ip => ${specific_ip_action^^} "
            read -p "Do you want to add Another IP (y/n): " op
            if [[ "$op" == "n" || "$op" == "N" ]]; then
                break
            fi
        done
    fi
}

handle_services() {
    # Ask user for connection types and ports to allow
    echo -e "${YELLOW}Specify connection types:${RESET}"
    read -p "Do you want to allow any specific Service  ? (y/n): " allow_specific_Ser
    if [ "$allow_specific_Ser" == "y" ] || [ "$allow_specific_Ser" == "Y" ]; then
        while [ true ]; do
            read -p "TCP/UDP/ALL: " protocol_input

            # Process protocol and port inputs
            if [ "$protocol_input" == "ALL" ]; then
                protocol="-p all"
            else
                protocol="-p $protocol_input"
            fi

            echo -e "${YELLOW}Specify ports or port ranges to allow: ${RESET}"
            read -p "Port (e.g., 80) or port range (e.g., 22-80): " port_input

            # Process port inputs
            IFS='-' read -ra port_range <<<"$port_input"
            if [ ${#port_range[@]} -eq 1 ]; then
                port="-m multiport --dports ${port_range[0]}"
            else
                port="-m multiport --dports ${port_range[0]}:${port_range[1]}"
            fi

            read -p "Do you want to accept or drop traffic ? (ACCEPT/DROP) : " action

            sudo iptables -A INPUT $protocol $port -j ${action^^}

            echo "Rules added $proto/$port_input => ${action^^} "
            read -p "Do you want to add Another service (y/n): " op
            if [[ "$op" == "n" || "$op" == "N" ]]; then
                break
            fi
        done
    fi
}

handle_multi_ports() {
    echo -e ""
}
