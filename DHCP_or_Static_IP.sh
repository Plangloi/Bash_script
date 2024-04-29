#!/bin/bash
#

maskdefault="255.255.255.0"
interface=$(ip route | awk '/default/ {print $5}')
echo "$interface"

# Function to configure DHCP
configure_dhcp() {
    echo "Configuring DHCP..."
    echo "source /etc/network/interface.d/*" | sudo tee /etc/network/interfaces
    echo "auto lo" | sudo tee -a /etc/network/interfaces
    echo "iface lo inet loopback" | sudo tee -a /etc/network/interfaces
    echo "allow-hotplug $interface" | sudo tee -a /etc/network/interfaces
    echo "iface $interface inet dhcp" | sudo tee -a /etc/network/interfaces
    echo "Done configuring DHCP."
}

# Function to configure Static IP
configure_static() {
    read -p "Enter static IP: " ip1
    read -p "Enter netmask (Or Enter for /24): " netmask
    if [[ -z "$netmask" ]]; then
        netmask=$maskdefault
    fi
    echo "======================================================"
    echo "Configuring Static IP..."
    echo "source /etc/network/interface.d/*" | sudo tee /etc/network/interfaces
    echo "iface lo inet loopback" | sudo tee -a /etc/network/interfaces
    echo "allow-hotplug $interface" | sudo tee -a /etc/network/interfaces
    echo "iface $interface inet static" | sudo tee -a /etc/network/interfaces
    echo "address $ip1" | sudo tee -a /etc/network/interfaces
    echo "netmask $netmask" | sudo tee -a /etc/network/interfaces
    echo "Done configuring Static IP."
}

# Display menu and process user choice
while true; do
    echo "1. Configure DHCP"
    echo "2. Configure Static IP"
    echo "3. Exit"
    read -p "Enter your choice (1-3): " choice
    case $choice in
        1) configure_dhcp ;;
        2) configure_static ;;
        3) echo "Exiting..."; exit ;;
        *) echo "Invalid choice. Please enter a number from 1 to 3." ;;
    esac
done
