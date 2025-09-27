#!/bin/bash
# morality firewall – Ubuntu/PrestaShop

echo "Flushing existing rules..."
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

echo "Setting default policies..."
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

echo "Allowing loopback and established connections..."
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

echo "Allowing SSH from team networks..."
iptables -A INPUT -p tcp -s 192.168.200.0/24 --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.192.0/18 --dport 22 -j ACCEPT

echo "Allowing morality web services traffic..."
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

echo "Adding logging rule (last)..."
iptables -A INPUT -j LOG --log-prefix "IPTables-Dropped: " --log-level 4

echo "Firewall rules applied."
iptables -L -v
