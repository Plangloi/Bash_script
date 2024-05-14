#!/bin/bash

# Function pause
function pause {
	echo ""
	echo ""
	echo "Enter to continue! "
	read
	main
	clear
}

# Function to quit the script.
function quiter {
	echo " Bye Bye! "
}

# Function to display the user's UID.

function afficheruid {
	read -p "Nom de lutilisateur : " uid_user
	uid=$(id $uid_user | awk '{print $1}')
	echo "L'uid de $uid_user est : $uid"
	pause
}
### Function to display Main Menu.
function affichagemenu {
	clear
	echo ""
	echo ""
	echo -e " \033[1;32m1-Information système\033[m "
	echo -e " \033[1;32m2-Gérer les utilisateurs\033[m "
	echo -e " \033[1;32m3-Gérer les groupes d’utilisateur\033[m "
	echo -e " \033[1;32m4-SSH\033[m "
	echo -e " \033[1;32m5-NMAP\033[m "
    echo -e " \033[1;32m6-Proxy setup\033[m "
    echo -e " \033[1;32m7-Dhcp or Static Ip\033[m "
	echo -e "\033[1;31m(Q)uitter\033[m "
	read -p "Main Menu [1-4] : " choix_menu
}

### Function to go dhcp or Static Ip.
function dhcpsetup {
	clear
    echo "DHCP"
    echo ""
    echo "1- DHCP"
    echo "2- Static Ip"
	echo ""
	echo "3-Quitter"
    read -p "dhcp or Static Ip [1-2] : " choix_dhcpsetup

    if [[ $choix_dhcpsetup -eq 1 ]]; then
        echo "DHCP"
        echo "Configuring DHCP..."
        echo ""

        echo "source /etc/network/interface.d/*" | sudo tee /etc/network/interfaces
        echo "auto lo" | sudo tee -a /etc/network/interfaces
        echo "iface lo inet loopback" | sudo tee -a /etc/network/interfaces
        echo "allow-hotplug $interface" | sudo tee -a /etc/network/interfaces
        echo "iface $interface inet dhcp" | sudo tee -a /etc/network/interfaces
        echo "Done configuring DHCP."


    elif [[ $choix_dhcpsetup -eq 2 ]]; then
        echo "Static Ip"
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

	else
	echo "Invalid choice!"
	main
    fi
    
    }



### Function Proxy on/off.
function addProxy {
    # Add proxy configuration to /etc/apt/apt.conf
    if [ ! -f "/etc/apt/apt.conf" ]; then
        sudo touch /etc/apt/apt.conf
        
    fi
    sudo bash -c 'echo "Acquire::http::proxy \"http://10.1.0.5:8080/\";" >> /etc/apt/apt.conf'
    sudo bash -c 'echo "Acquire::https::proxy \"https://10.1.0.5:8080/\";" >> /etc/apt/apt.conf'
    sudo bash -c 'echo "proxy=http://10.1.0.5:8080" >> /etc/dnf/dnf.conf'
    # sudo bash -c 'echo "proxy=https://10.1.0.5:8080" >> /etc/dnf/dnf.conf'
    
    # sudo bash -c 'echo "Acquire::ftp::proxy \"ftp://10.1.0.5:8080/\";" >> /etc/apt/apt.conf'
    

    # Add proxy configuration to ~/.bashrc
    echo 'export http_proxy=http://10.1.0.5:8080' >> ~/.bashrc
    echo 'export https_proxy=http://10.1.0.5:8080' >> ~/.bashrc
    echo 'export ftp_proxy=ftp://10.1.0.5:8080' >> ~/.bashrc

    # Source the ~/.bashrc file to apply changes immediately
    . ~/.bashrc
    echo "Proxy is now on!"

}

### Option to remove proxy configuration
function removeproxy {
    sudo bash -c 'sed -i "/Acquire::http/d" /etc/apt/apt.conf'
    sudo bash -c 'sed -i "/Acquire::https/d" /etc/apt/apt.conf'
    sudo bash -c 'sed -i "/Acquire::ftp/d" /etc/apt/apt.conf'
    echo "Proxy settings have been removed successfully."

}

# Function to add Proxy.
function proxyMenu {
    clear
    echo ""
    echo "----------------------"
    echo "Proxy setup"
    echo "----------------------"
    echo "1-Add  add Proxy"
    echo "2-Remove Proxy"
    echo "3-Display Proxy"
    echo "4-Quit"
    read -p "Proxy Menu [1-4] : " choix_proxy

        case $choix_proxy in

        1)
        clear
        addProxy
        ;;

            2)
            clear
            removeproxy
            ;;

                3)
                clear
                echo "Proxy settings are currently:"
                echo ""
                echo "http_proxy = $http_proxy"
                echo "https_proxy = $https_proxy"
                echo "ftp_proxy = $ftp_proxy"
                ;;

                    4)
                    clear
                    quiter
                    ;;
                        *)
                        clear
                        echo "Invalid option."
                        sleep 2
                        main
                        ;;
        esac
}
    
    

#Function to add user.

#Function to display system information.
function montools {
	echo "          a-Afficher la version Linux"
	echo "          b-Afficher le nom de l'utilisateur de la session actuelle : "
	echo "          c-Afficher la date système "
	echo -e "\033[1;33m(M)Main menu\033[m "
	echo -e "\033[1;31m(Q)uitter\033[m "

	read -p "           Menu Information Systeme [a-c] : " montools_input

	case $montools_input in
	a)
		clear
		cat /etc/os-release
		pause
		;;
	b)
		clear
		echo "Votre nom est : "
		whoami
		pause
		;;
	c)
		clear
		echo "La date est : "
		date +"Année: %Y, Mois: %m, Jour: %d"
		pause
		;;
	q)
		quiter
		;;
	m)
		affichagemenu
		;;
	*)
		clear
		echo "Choix invalide ! "
		sleep 1
        main
		;;
	esac
}

#Function to display SSH
function ssh1 {
	echo " 1-SSH install"
	echo " 2-SSH On"
	echo " 3-SSH Off"
	echo -e "\033[1;33m4-Main menu\033[m "

	read -p " Choisir 1 -3 " ssh1choix
	case $ssh1choix in
    1)
        sudo apt-get update && sudo apt install
        ;;
    2)
        echo "systemctl start ssh"
        ;;
    3)
        echo "systemctl stop ssh"
        ;;
    4)
        affichagemenu
        ;;
    *)
        echo "maivais choix"
        main
        ;;

esac
}

#Function to display NMAP
function nmap1 {
	echo "1-Nmap install"
	echo "2-Nmap port ouvert"
	echo -e "\033[1;33m3-Main menu\033[m "

	read -p " Choisir 1 or 3 : " netstatchoix

	if [[ $netstatchoix -eq 1 ]]; then
		sudo apt install nmap
		pause
	elif [[ $netstatchoix -eq 2 ]]; then
		read -p " target ip : (192.168.1.1/24) ?" target
		read -p " Path for save scan ?" chemin
		nmap -sT"$target" >$chmain
		pause

	elif [[ $netstatchoix -eq 3 ]]; then
		affichagemenu

	else
		echo "Maivais choix"
		pause
	fi
}
cd
function groups_user {
	echo "          a-Ajouter un nouveau groupe d’utilisateurs "
	echo "          b-Supprimer un groupe d’utilisateurs "
	echo "          c-Ajouter un utilisateur à un groupe d’utilisateurs "
	echo "          d-Retirer un utilisateur d’un groupe d’utilisateurs "
	echo -e "\033[1;33m(M)Main menu\033[m "
	echo -e "\033[1;31m(Q)uitter\033[m \n"

	read -p " Gérer les groupes d’utilisateur : [a-d] : " group_input
	if [[ $group_input == a ]]; then

		read -p " Group a ajouter ? : " new_group
		sudo groupadd $new_group
		echo "Le $new_group a ete ajouter !"
		pause

	elif [[ $group_input == b ]]; then
		read -p " Group a Supprimer ? : " del_group
		read -p " Supprimer le Group $del_group (y/n) ?" choix_del_group
		if [[ $choix_del_group == y ]]; then
			sudo groupdel "$del_group"
			echo "Le $del_group a ete suprimmer !"
			pause

		else
			echo "Canceling.....Supression de Group! "
			sleep 1
			clear
			groups_user
		fi

	elif [[ $group_input == c ]]; then
		read -p " Ajouter utilisateur (nom) ? : " add_user_group
		read -p " Ajouter utilisateur au groupe (nom du group) ? :" group_name

		read -p " Ajouter $add_user_group au groupe $group_name (y/n) ?" choix_add_user_group
		if [[ $choix_add_user_group == y ]]; then
			sudo usermod -aG "$group_name $add_user_group"
			echo "Lutilisateur $add_user_group a ete ajouter au group $group_name !"
			pause

		else
			echo "Canceling.....addition de $add_user_group au groupe $group_name ! "
			sleep 1
			clear
			groups_user
		fi

	elif [[ $group_input == d ]]; then
		read -p " Retirer utilisateur (nom) ? : " del_user_group
		read -p " Retirer $del_user_group de quelle groupe (nom du group) ? :" del_group_name

		read -p " Retirer $del_user_group au groupe $del_group_name (y/n) ?" choix_del_user_group
		if [[ $choix_del_user_group == y ]]; then
			sudo gpasswd --delete $del_user_group $del_group_name
			echo "Lutilisateur $del_user_group a ete suprimmer du Group $del_group_name !"
			pause

		else
			echo "Canceling.....Supression de $del_user_group au groupe $del_group_name ! "
			sleep 1
			clear
			groups_user
		fi

	elif [[ $group_input == m ]]; then
		affichagemenu

	elif [[ $group_input == q ]]; then
		quiter

	else
		clear
		echo "Choix invalide !! "
		sleep 1

	fi
}

function usertools {
	echo "          a-Ajouter un utilisateur "
	echo "          b-Supprimer un utilisateur "
	echo -e "\033[1;33m(M)Main menu\033[m "
	echo -e "\033[1;31m(Q)uitter\033[m \n"

	read -p " Gérer les utilisateurs [a-b] : " usert

	if [[ $usert == a ]]; then
		read -p " Nom pour utilisateur? : " new_user
		read -p " Ajouter $new_user (y/n) ?" choix_menu_newuser
		if [[ $choix_menu_newuser == y ]]; then
			sudo adduser $new_user

		else
			echo "Canceling.....user addition! "
			sleep 1
			clear
			usertools
		fi

	elif [[ $usert == b ]]; then
		read -p " Utilisateur a Supprimer? : " del_new_user
		read -p " Supprimer $new_user (y/n) ?" del_choix_menu_newuser
		if [[ $del_choix_menu_newuser == y ]]; then
			sudo userdel $del_new_user
			echo "Utilisateur $del_new_user suprimmer....."
			sleep 1

		else
			echo "Canceling.....Suppression utilisateurs ! "
			sleep 1
			clear
			usertools
		fi

	elif [[ $usert == m ]]; then
		affichagemenu

	elif [[ $usert == q ]]; then
		quiter

	else
		echo " Mauvais choix! "
		sleep 1
		clear
		usertools

	fi
}

function main {

	affichagemenu

	case $choix_menu in
	1)
		montools
		;;
	2)
		usertools
		;;
	3)
		groups_user
		;;
	4)
		ssh1
		;;
	5)
		nmap1
		;;

    6)
        proxyMenu
        ;;

    7)
        dhcpsetup
        ;;
        

	q)
		quiter
		;;
	*)
		echo " Mauvais choix_menu "
		;;
	esac
}
main
