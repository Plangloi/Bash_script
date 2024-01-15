#!/bin/bash

read -p "Nom :" nom
read -p "Prenom :" prenom

stop=0

  while read line; do
	set -- $line
	  if [[ $nom == $1 && $prenom == $2 ]]; then
		  echo "Le password pour $1 $2 est $3"
		  stop=1
	  fi

done < name.txt

if [[ $stop == 0 ]]; then
	if [[ $nom != $1 && $prenom != $2 ]]; then
		echo "Nom & Prenom est Mauvais !"

	elif [[ $nom != $1 ]]; then
		echo "Mauvais Nom! "

	elif [[ $prenom != $2 ]]; then
		echo "Mauvais Prenom !"

	fi

fi

echo "fin"
