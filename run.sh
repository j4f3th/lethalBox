#!/usr/bin/env bash


#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"
grayColour="\e[0;37m\033[1m"
blueColour="\e[0;34m\033[1m"


# force to tell what's wrong if the script fails and goes to the path where the script lives

set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")/docker"


# take sudo password
sudo -v


echo -e "${yellowColour}[+]${endColour}${blueColour} Opening shell...${endColour}"
if(sudo docker compose exec lab bash); then # opening shell
  echo '';
else
  echo -e "\n${redColour}[!] Error opening shell${endColour}\n";
fi

