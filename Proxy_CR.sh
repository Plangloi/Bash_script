#!/bin/bash

# Proxy server details (change these if different)
PROXY_SERVER="10.1.0.5"
PROXY_PORT="8080"

# Function to display the menu
function display_menu {
  clear
  echo ""
  echo -e "\033[1;32m1- Enable Proxy for Rosemont College\033[m"
  echo -e "\033[1;31m2- Disable Proxy\033[m"
  echo ""

  echo -e "\033[1;31m(Q) Quit\033[m"
  read -p "Main Menu [1-2 or Q] : " choice
}

# Function to enable proxy
function enable_proxy {
  # Add proxy configuration to /etc/apt/apt.conf
  sudo bash -c "echo \"Acquire::http::proxy 'http://${PROXY_SERVER}:${PROXY_PORT}/';\" >> /etc/apt/apt.conf"
  sudo bash -c "echo \"Acquire::https::proxy 'https://${PROXY_SERVER}:${PROXY_PORT}/';\" >> /etc/apt/apt.conf"

  # Add proxy configuration to ~/.bashrc
  echo "export http_proxy=http://${PROXY_SERVER}:${PROXY_PORT}" >> ~/.bashrc
  echo "export https_proxy=https://${PROXY_SERVER}:${PROXY_PORT}" >> ~/.bashrc
  echo "export ftp_proxy=http://${PROXY_SERVER}:${PROXY_PORT}" >> ~/.bashrc

  # Source the ~/.bashrc file to apply changes immediately
  source ~/.bashrc

  echo "Proxy settings for Rosemont College enabled successfully."
}

# Function to disable proxy
function disable_proxy {
  # Remove proxy configuration lines from /etc/apt/apt.conf
  sudo sed -i '/Acquire::http::proxy/d' /etc/apt/apt.conf
  sudo sed -i '/Acquire::https::proxy/d' /etc/apt/apt.conf

  # Remove proxy configuration lines from ~/.bashrc
  sed -i '/http_proxy/d' ~/.bashrc
  sed -i '/https_proxy/d' ~/.bashrc
  sed -i '/ftp_proxy/d' ~/.bashrc

  # Source the ~/.bashrc file to apply changes immediately
  source ~/.bashrc

  echo "Proxy settings for Rosemont College disabled successfully."
}

# Main function to handle user choice
function main {
  case "${choice}" in
    1)
      enable_proxy 
      ;;
    2)
      disable_proxy
      ;;
    q|Q)
      echo "Exiting..."
      ;;
    *)
      echo "Invalid choice. Please select 1, 2, or Q."
      ;;
  esac
}

# Call the menu function and then the main function
display_menu
main
