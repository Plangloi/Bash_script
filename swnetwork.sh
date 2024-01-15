#!/bin/bash
#

maskdefault=""255.255.255.0""
interface=wlp36s0

read -p "1-DHCP ou 2-Static (1 or 2) :" choix

	if [[ $choix == 1 ]]; then
		echo "source /etc/network/interface.d/*" > /etc/network/interfaces.bk
		echo "auto lo" >> /etc/network/interfaces.bk
		echo "iface lo inet loopback" >> /etc/network/interfaces.bk
		echo "allow-hotplug $interface" >> /etc/network/interfaces.bk
		echo "iface $interface inet dhcp" >> /etc/network/interfaces.bk
		
		echo "Mode DHCP activited ..."

 	elif [[ $choix == 2 ]]; then
		read -p "Enter static ip  :" ip1
		read -p "Enter netmask  :" netmask
			if [[ -z "$netmask" ]]; then
				netmask=$maskdefault
			fi
		echo "source /etc/network/interface.d/*" > /etc/network/interfaces.bk
		echo "iface lo inet loopback" >> /etc/network/interfaces.bk
		echo "allow-hotplug $interface" >> /etc/network/interfaces.bk
		echo "iface $interface inet static" >> /etc/network/interfaces.bk
		echo "address $ip1" >> /etc/network/interfaces.bk
		echo "netmask $netmask" >> /etc/network/interfaces.bk

		echo "Mode Static activited ..."
		echo "ip is : $ip1"
		echo "mask is : $netmask"
 	fi

echo "done"	
