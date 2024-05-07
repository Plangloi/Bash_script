#!/bin/bash

# Add proxy configuration to /etc/apt/apt.conf
sudo bash -c 'echo "Acquire::http::proxy \"http://10.1.0.5:8080/\";" >> /etc/apt/apt.conf'
sudo bash -c 'echo "Acquire::https::proxy \"https://10.1.0.5:8080/\";" >> /etc/apt/apt.conf'

# Add proxy configuration to ~/.bashrc
echo 'export http_proxy=http://10.1.0.5:8080' >> ~/.bashrc
echo 'export https_proxy=http://10.1.0.5:8080' >> ~/.bashrc
echo 'export ftp_proxy=http://10.1.0.5:8080' >> ~/.bashrc

# Source the ~/.bashrc file to apply changes immediately
source ~/.bashrc

echo "Proxy settings have been applied successfully."
