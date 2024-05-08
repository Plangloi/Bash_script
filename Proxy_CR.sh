#!/bin/bash
#v1_ok
# Add proxy configuration to /etc/apt/apt.conf
#sudo bash -c 'echo "Acquire::http::proxy \"http://10.1.0.5:8080/\";" >> /etc/apt/apt.conf'
#sudo bash -c 'echo "Acquire::https::proxy \"https://10.1.0.5:8080/\";" >> /etc/apt/apt.conf'

# Add proxy configuration to ~/.bashrc
#echo 'export http_proxy=http://10.1.0.5:8080' >> ~/.bashrc
#echo 'export https_proxy=http://10.1.0.5:8080' >> ~/.bashrc
#echo 'export ftp_proxy=http://10.1.0.5:8080' >> ~/.bashrc

# Source the ~/.bashrc file to apply changes immediately
#source ~/.bashrc

#echo "Proxy settings have been applied successfully."
=========================================================================================
#New_v2
# Add proxy configuration to /etc/apt/apt.conf
if [ ! -f "/etc/apt/apt.conf" ]; then
    sudo touch /etc/apt/apt.conf
fi
sudo bash -c 'echo "Acquire::http::proxy \"http://10.1.0.5:8080/\";" >> /etc/apt/apt.conf'
sudo bash -c 'echo "Acquire::https::proxy \"https://10.1.0.5:8080/\";" >> /etc/apt/apt.conf'
sudo bash -c 'echo "Acquire::ftp::proxy \"ftp://10.1.0.5:8080/\";" >> /etc/apt/apt.conf'

# Add proxy configuration to ~/.bashrc
echo 'export http_proxy=http://10.1.0.5:8080' >> ~/.bashrc
echo 'export https_proxy=http://10.1.0.5:8080' >> ~/.bashrc
echo 'export ftp_proxy=ftp://10.1.0.5:8080' >> ~/.bashrc

# Source the ~/.bashrc file to apply changes immediately
source ~/.bashrc

# Option to remove proxy configuration
if [ "$1" = "--remove" ]; then
    sudo bash -c 'sed -i "/Acquire::http/d" /etc/apt/apt.conf'
    sudo bash -c 'sed -i "/Acquire::https/d" /etc/apt/apt.conf'
    sudo bash -c 'sed -i "/Acquire::ftp/d" /etc/apt/apt.conf'
    echo "Proxy settings have been removed successfully."
fi
