#!/bin/bash

out=0

function pause {
	echo ""
	echo ""
	echo "Enter to continue! "
	read
	clear
}

function quiter {
	echo " Bye Bye! "
	out=1
}

function afficheruid {
	read -p "Nom de lutilisateur : " uid_user
	uid=$(id $uid_user | awk '{print $1}')
	echo "L'uid de $uid_user est : $uid"
	pause
}

function affichagemenu {
	clear
	echo ""
	echo ""
	echo -e " \033[1;32m1-Information système\033[m "
	echo -e " \033[1;32m2-Gérer les utilisateurs\033[m "
	echo -e " \033[1;32m3-Gérer les groupes d’utilisateur\033[m "
	echo -e " \033[1;32m4-SSH\033[m "
  	echo -e " \033[1;32m5-NMAP\033[m " 
	echo -e "\033[1;31m(Q)uitter\033[m "
	read -p "Main Menu [1-4] : " choix_menu
}

function montools {
	echo "          a-Afficher la version Linux"
	echo "          b-Afficher le nom de l'utilisateur de la session actuelle : "
	echo "          c-Afficher la date système "
	echo -e "\033[1;33m(M)Main menu\033[m "
	echo -e "\033[1;31m(Q)uitter\033[m "

	read -p "           Menu Information Systeme [a-c] : " montools_input

	if [[ $montools_input == a ]]; then
		clear
		cat /etc/os-release
		pause

	elif [[ $montools_input == b ]]; then
		clear
		echo "Votre nom est : "
		whoami
		pause

	elif [[ $montools_input == c ]]; then
		clear
		echo "La date est : "
		date +"Année: %Y, Mois: %m, Jour: %d"
		pause

	elif [[ $montools_input == q ]]; then
		quiter

	elif [[ $montools_input == m ]]; then
		affichagemenu

	else
		clear
		echo "Choix invalide ! "
		sleep 1

	fi
}
function ssh1 {
        echo " 1-SSH install"
        echo " 2-SSH On"
        echo " 3-SSH Off"
        echo -e "\033[1;33m4-Main menu\033[m "


        read -p " Choisir 1 -3 " ssh1choix
        if [[ $ssh1choix -eq 1 ]]; then
            sudo apt-get update && sudo apt install 

        elif [[ $ssh1choix -eq 2 ]]; then
            echo "choix 2"

        elif [[ $ssh1choix -eq 3 ]]; then
            echo "choix 3"

        elif [[ $ssh1choix -eq 4 ]]; then
            affichagemenu

        else
            echo "maivais choix"
        fi
     }

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
            nmap -sT"$target" > $chmain
            pause

        elif [[ $netstatchoix -eq 3 ]]; then
            affichagemenu

        else
            echo "Maivais choix"
            pause
        fi
}


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

	while [[ $out -eq 0 ]]; do

		if [[ $choix_menu -eq 1 ]]; then
			montools

		elif [[ $choix_menu -eq 2 ]]; then
			usertools

		elif [[ $choix_menu -eq 3 ]]; then
			groups_user

		elif [[ $choix_menu -eq 4 ]]; then
			ssh1

		elif [[ $choix_menu -eq 5 ]]; then
			nmap1


		elif [[ "$choix_menu" = "q" ]]; then
			quiter

		else
			echo " Mauvais choix_menu "
			sleep 2
			affichagemenu
		fi
	done
}

fichagemenu
main
