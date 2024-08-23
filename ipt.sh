#!/bin/bash

source "lib/basic.sh"
source "lib/rule_adding.sh"
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

basic
handle_ip_traffic
handle_services

sudo iptables -L -v -n
sudo iptables -F

echo "Flusing all the Rules....!"

# iptables -A INPUT -i lo -j $LOOPBACK_POLICY
