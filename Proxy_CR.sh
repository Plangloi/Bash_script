#!/bin/bash

# Variables
PROXY_SERVER="10.1.0.5"
PROXY_PORT="8080"

# Functions and Main Menu
function display_menu {
  clear
  echo ""
  echo -e "\033[1;32m1- Enable Proxy\033[m"
  echo -e "\033[1;31m2- Disable Proxy\033[m"
  echo ""

  echo -e "\033[1;31m(Q) Quit\033[m"
  read -p "Main Menu [1-2 or Q] : " choice
}
# Enable Proxy
function enable_proxy {
  sudo bash -c "echo \"Acquire::http::proxy 'http://${PROXY_SERVER}:${PROXY_PORT}/';\" >>
/etc/apt/apt.conf.d/proxy"
  sudo bash -c "echo \"Acquire::https::proxy 'https://${PROXY_SERVER}:${PROXY_PORT}/';\" >>
/etc/apt/apt.conf.d/proxy"

  echo "export http_proxy=http://${PROXY_SERVER}:${PROXY_PORT}" >> ~/.bashrc
  echo "export https_proxy=https://${PROXY_SERVER}:${PROXY_PORT}" >> ~/.bashrc
  echo "export ftp_proxy=http://${PROXY_SERVER}:${PROXY_PORT}" >> ~/.bashrc

  source ~/.bashrc

  echo "Proxy settings enabled successfully."
}
# Disable Proxy
function disable_proxy {
  sudo sed -i '/Acquire::http::proxy/d' /etc/apt/apt.conf.d/proxy
  sudo sed -i '/Acquire::https::proxy/d' /etc/apt/apt.conf.d/proxy

  sed -i '/http_proxy/d' ~/.bashrc
  sed -i '/https_proxy/d' ~/.bashrc
  sed -i '/ftp_proxy/d' ~/.bashrc

  source ~/.bashrc

  echo "Proxy settings disabled successfully."
}
#Main Menu
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
