#!/bin/bash
# anger firewall – OPNsense (edge box)

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

# === SSH (from team management networks only) ===
echo "Allowing SSH from team subnets..."
iptables -A INPUT -p tcp -s 192.168.200.0/24 --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.192.0/18 --dport 22 -j ACCEPT

# === OPNsense Web Admin (HTTPS) – LAN only ===
echo "Allowing OPNsense web GUI from LAN only..."
iptables -A INPUT -p tcp -d 172.16.1.1 --dport 443 -j ACCEPT

# === OPTIONAL: allow DNS if OPNsense is providing resolver ===
# echo "Allowing DNS (UDP/TCP 53)..."
iptables -A INPUT -p udp -s 172.16.1.0/24 --dport 53 -j ACCEPT
iptables -A INPUT -p tcp -s 172.16.1.0/24 --dport 53 -j ACCEPT

# === OPTIONAL: allow DHCP if needed (67/68) ===
 iptables -A INPUT -p udp -s 172.16.1.0/24 --dport 67:68 -j ACCEPT

# === Logging last ===
echo "Adding logging rule..."
iptables -A INPUT -j LOG --log-prefix "IPTables-Dropped: " --log-level 4

echo "Firewall rules applied."
iptables -L -v
