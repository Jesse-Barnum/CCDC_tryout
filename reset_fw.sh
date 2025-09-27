#!/bin/bash
echo "Resetting firewall to default ACCEPT..."
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
echo "Firewall reset complete"

