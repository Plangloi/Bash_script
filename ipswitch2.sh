#!/bin/bash

# Detect the active network interface
interface=$(ip route | awk '/^default/ {print $5}')

# Ask the user for network configuration choice
read -p "Do you want to configure the network with DHCP or a static IP? (dhcp/static): " choice

if [ "$choice" == "static" ]; then
    # Set the static IP configuration
    read -p "Enter the static IP address: " static_ip
    read -p "Enter the netmask: " netmask
    read -p "Enter the gateway: " gateway
    read -p "Enter DNS servers (space-separated): " dns_servers

    # Backup the current configuration
    cp "/etc/network/interfaces" "/etc/network/interfaces.backup"

    # Update the network configuration
    cat > "/etc/network/interfaces" <<EOL
auto $interface
iface $interface inet static
    address $static_ip
    netmask $netmask
    gateway $gateway
    dns-nameservers $dns_servers
EOL

    echo "Network configuration updated to static IP."

else
    # Use DHCP
    # Backup the current configuration
    cp "/etc/network/interfaces" "/etc/network/interfaces.backup"

    # Update the network configuration for DHCP
    cat > "/etc/network/interfaces" <<EOL
auto $interface
iface $interface inet dhcp
EOL

    echo "Network configuration updated to use DHCP."
fi

# Restart the networking service
systemctl restart networking
