#!/bin/bash

source "lib/colors.sh"

basic() {
    #Routing from WAN to LAN
    local interface="$1"
    sudo iptables -t nat -A POSTROUTING -o "$interface" -j MASQUERADE
    sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    echo -e "${GREEN}Rules added For basic Firewall Packet Forwarding${RESET}"
    sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    sudo iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT
    echo -e "${GREEN}Rules added tcp/22 => Allow${RESET} "

    # Ask user to set default policies
    # sudo iptables -A INPUT -i "$interface" -j "$default_policy_input"
    echo -e "${YELLOW}Set default input policy for loopback: ${RESET}"
    read -p "ACCEPT/DROP: " default_policy_input
    if [ -z "${default_policy_input}" ]; then
        default_policy_input="ACCEPT"
    fi

    # echo "sudo iptables -P INPUT ${default_policy_input^^}"
    sudo iptables -P INPUT ${default_policy_input^^}
    sudo iptables -P FORWARD ${default_policy_input^^}
    echo -e "${YELLOW}Set loopback traffic policy: ${RESET}"
    read -p "ACCEPT/DROP: " loopback_policy_input
    if [ -z "${loopback_policy_input}" ]; then
        loopback_policy_input="ACCEPT"
    fi
    sudo iptables -A INPUT -i lo -j ${loopback_policy_input^^}

    # Set default output rule
    sudo iptables -P OUTPUT ACCEPT

    # ==============================================================================================================#

    echo -e "${YELLOW}Set default policy for http and https: ${RESET}"
    read -p "ACCEPT/DROP: " default_policy_input
    if [ -z "${default_policy_input}" ]; then
        default_policy_input="ACCEPT"
    else
        default_policy_input="DROP"
    fi
    sudo iptables -A INPUT -p tcp -i $interface -m multiport --dports 80,443 -j ${default_policy_input^^}
    sudo iptables -A OUTPUT -p tcp -i $interface -m multiport --dports 80,443 -j ${default_policy_input^^}

    echo -e "${GREEN}Rules added Http&Https => ${default_policy_input^^} ${RESET} "

    # ==============================================================================================================#

    echo -e "${YELLOW}Set default  policy for FTP and SFTP: ${RESET}"
    read -p "ACCEPT/DROP: " default_policy_input
    if [ -z "${default_policy_input}" ]; then
        default_policy_input="ACCEPT"
    else
        default_policy_input="DROP"
    fi
    sudo iptables -A INPUT -p tcp --dport 22 -m string --string "sftp" --algo bm -j $default_policy_input
    sudo iptables -A INPUT -p tcp --dport 22 -m string --string "subsystem" --algo bm -j $default_policy_input
    sudo iptables -A INPUT -p tcp -port 21 -i $interface -j ${default_policy_input^^}

    sudo iptables -A OUTPUT -p tcp --dport 22 -m string --string "sftp" --algo bm -j $default_policy_input
    sudo iptables -A OUTPUT -p tcp --dport 22 -m string --string "subsystem" --algo bm -j $default_policy_input
    sudo iptables -A OUTPUT -p tcp -port 21 -i $interface -j ${default_policy_input^^}

    echo -e "${GREEN}Rules added FTP&SFTP => ${default_policy_input^^} ${RESET} "

    # ==============================================================================================================#

    echo -e "${YELLOW}Set default policy for EMail : ${RESET}"
    read -p "ACCEPT/DROP: " default_policy_input
    if [ -z "${default_policy_input}" ]; then
        default_policy_input="ACCEPT"
    else
        default_policy_input="DROP"
    fi

    sudo iptables -A INPUT -p tcp -m multiport --dports 25,587,465,110,995,143,993 -j ${default_policy_input^^}
    sudo iptables -A OUTPUT -p tcp -m multiport --dports 25,587,465,110,995,143,993 -j ${default_policy_input^^}

    echo -e "${GREEN}Rules added FTP&SFTP => ${default_policy_input^^} ${RESET} "

    # ==============================================================================================================#

    # ==============================================================================================================#

}
