#!/bin/bash

source "lib/basic.sh"
source "lib/rule_handling.sh"
source "lib/colors.sh"
source "lib/define.sh"
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
clear

while [ true ]; do
    echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
    echo -e "${BRIGHT_YELLOW}Menu${RESET}"
    echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
    echo -e "${BRIGHT_WHITE} ${option1}${RESET}"
    echo -e "${BRIGHT_WHITE} ${option2}${RESET}"
    echo -e "${BRIGHT_WHITE} ${option3}${RESET}"
    echo -e "${BRIGHT_WHITE} ${option4}${RESET}"
    echo -e "${BRIGHT_WHITE} ${option5}${RESET}"
    echo -e "${BRIGHT_WHITE} ${option6}${RESET}"
    echo -e "${BRIGHT_WHITE} ${option7}${RESET}"
    echo -e "${BRIGHT_WHITE} ${option8}${RESET}"
    echo -e "${BRIGHT_WHITE} ${option90}${RESET}"
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
        echo "You have selected the option 5"
        see_all_interfaces
        ;;
    6)
        echo "You have selected the option 6"
        View_rules
        ;;
    7)
        echo "You have selected the option 7"
        echo -e "${CYAN} SAVING RULES .... > rules.v4${RESET}"
        sudo iptables-save >rules.v4
        sudo iptables-save >/etc/iptables/rules.v4
        sudo systemctl restart iptables
        echo -e "${CYAN}Done..${RESET}"
        ;;
    8)
        echo "You have selected the option 8"
        echo -e "${BRIGHT_BLUE}Restart iptables ${RESET}"
        sudo systemctl restart iptables
        ;;
    9)
        echo "Quitting ..."
        # exit
        break
        ;;
    *) echo "invalid option" ;;
    esac
    # clear
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
