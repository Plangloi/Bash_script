#!/bin/bash
#

maskdefault=""255.255.255.0""
interface=wlo1

read -p "1-DHCP ou 2-Static (1 or 2) :" choix

	if [[ $choix == 1 ]]; then
		echo "source /etc/network/interface.d/*" | sudo tee /etc/network/interfaces
		echo "auto lo" | sudo tee -a /etc/network/intierfaces
		echo "iface lo inet loopback" | sudo tee -a /etc/network/interfaces
		echo "allow-hotplug $interface" | sudo tee -a /etc/network/interfaces
		echo "iface $interface inet dhcp" | sudo tee -a /etc/network/interfaces
		
		echo "Mode DHCP activited ..."

 	elif [[ $choix == 2 ]]; then
		read -p "Enter static ip  :" ip1
		read -p "Enter netmask (Or Enter fo /24)  :" netmask
			if [[ -z "$netmask" ]]; then
				netmask=$maskdefault
			fi
		echo "======================================================" 
		echo "Righting to file ....."
		echo 

		echo "source /etc/network/interface.d/*" | sudo tee /etc/network/interfaces
		echo "iface lo inet loopback" | sudo tee -a /etc/network/interfaces
		echo "allow-hotplug $interface" | sudo tee -a /etc/network/interfaces
		echo "iface $interface inet static" | sudo tee -a /etc/network/interfaces
		echo "address $ip1" | sudo tee -a /etc/network/interfaces
		echo "netmask $netmask" | sudo tee -a /etc/network/interfaces
		echo "======================================================" 
		echo 

		echo "Mode Static activited ..."
		echo "ip is : $ip1"
		echo "mask is : $netmask"
 	fi


# Restart the networking service
systemctl restart networking
echo "done"	
