#!/bin/bash

# Define the server address or IP
SERVER="your_server_ip_or_domain"

# Define the timeout for the connection attempt
TIMEOUT=5

# Function to check server status
check_server() {
    if ping -c 1 -W "$TIMEOUT" "$SERVER" >/dev/null; then
        echo "Server is UP."
    else
        echo "Server is DOWN."
    fi
}

# Function to check server filesystem
check_filesystem() {
    if ssh "$SERVER" df -hT / | grep -q "Filesystem"; then
        echo "Filesystem is available."
    else
        echo "Filesystem is NOT available."
    fi
}

# Main script
echo "Checking Server Status..."
check_server

echo "Checking Filesystem..."
check_filesystem
