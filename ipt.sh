#!/bin/bash

source "lib/basic.sh"
source "lib/rule_adding.sh"
source "lib/colors.sh"

# Default policies
DEFAULT_POLICY="DROP"
LOOPBACK_POLICY="ACCEPT"

interface=""

see_all_interfaces
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

while [ true ]; do
    echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
    echo -e "${BRIGHT_YELLOW}Menu${RESET}"
    echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
    echo -e "${BRIGHT_WHITE} 1.Add Ip rule${RESET}"
    echo -e "${BRIGHT_WHITE} 2.Add service rule${RESET}"
    echo -e "${BRIGHT_WHITE} 3.port Forwarding${RESET}"
    echo -e "${BRIGHT_WHITE} 4.Create network segment${RESET}"
    echo -e "${BRIGHT_WHITE} 5.See Avilable Interfaces ${RESET}"
    echo -e "${BRIGHT_WHITE} 6.save IPTables rules${RESET}"
    echo -e "${BRIGHT_WHITE} 7.Restart Iptables${RESET}"
    echo -e "${BRIGHT_WHITE} 8.Quit${RESET}"
    echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
    echo -e "Enter your menu choice ${BRIGHT_MAGENTA}[1-3]${RESET}: "
    read choice
    case $choice in
    1)
        echo "You have selected the option 1"
        handle_ip_traffic
        ;;
    2)
        echo "You have selected the option 2"
        handle_services
        ;;
    3)
        echo "You have selected the option 3"
        port_forwarding $interface
        ;;
    4)
        echo "You have selected the option 4"
        create_network_segments
        ;;
    5)
        echo "You have selected the option 4"
        see_all_interfaces
        ;;
    6)
        echo "You have selected the option 4"
        echo -e "${CYAN} SAVING RULES .... > rules.v4${RESET}"
        sudo iptables-save >rules.v4
        sudo iptables-save >/etc/iptables/rules.v4
        sudo systemctl restart iptables
        echo -e "${CYAN}Done..${RESET}"
        ;;
    7)
        echo "You have selected the option 5"
        echo -e "${BRIGHT_BLUE}Restart iptables ${RESET}"
        sudo systemctl restart iptables
        ;;
    8)
        echo "Quitting ..."
        # exit
        break
        ;;
    *) echo "invalid option" ;;

    esac
done
echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
sudo iptables -L -v -n
echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
sudo iptables -t nat -L
echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"

sudo iptables -F
sudo iptables -t nat -F

echo -e "${CYAN}Flusing all the Rules....!"

# iptables -A INPUT -i lo -j $LOOPBACK_POLICY
