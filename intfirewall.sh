#!/bin/bash
# Firewall rules for INTELLIGENCE (Fedora, Splunk host)

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

echo "Allowing Splunk services..."
# Splunk Web UI
iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
# Splunk Management Port
iptables -A INPUT -p tcp --dport 8089 -j ACCEPT
# Splunk Index
iptables -A INPUT -p tcp --dport 9997 -j ACCEPT
# Splunk KV 
iptables -A INPUT -p tcp --dport 8191 -j ACCEPT

echo "Outbound DNS only"
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

iptables -A INPUT -j LOG --log-prefix "INTELLIGENCE-Dropped: " --log-level 4

echo "Firewall rules applied to INTELLIGENCE"
iptables -L -v
