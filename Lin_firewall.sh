#!/bin/bash
# firewall.sh – UFW firewall rules for CCDC
# Run as root (sudo ./firewall.sh)

echo "[*] Resetting UFW rules..."
ufw --force reset

echo "[*] Setting default policies..."
ufw default deny incoming
ufw default allow outgoing

# === ALLOW ESSENTIAL SERVICES ===
echo "[*] Allowing SSH (only from team VPN/IP)..."
# Replace x.x.x.x with your team’s IP / VPN range
ufw allow from x.x.x.x to any port 22 proto tcp

echo "[*] Allowing web traffic (HTTP/HTTPS)..."
ufw allow 80/tcp
ufw allow 443/tcp

# === OPTIONAL SERVICES (uncomment if needed) ===
# ufw allow 53        # DNS
# ufw allow 25        # Mail (SMTP)
# ufw allow 110       # POP3
# ufw allow 143       # IMAP

# === ENABLE FIREWALL ===
echo "[*] Enabling UFW..."
ufw --force enable

echo "[*] Current status:"
ufw status verbose

echo "It works"
