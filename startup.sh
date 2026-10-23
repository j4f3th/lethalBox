#!/usr/bin/env bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
grayColour="\e[0;37m\033[1m"

log=$(mktemp)

set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"


sudo -v

trap ctrl_c INT


function ctrl_c(){
	echo -e "\n\n${yellowColour}[*]${endColour}${grayColour}\t Exiting... ${endColour}\n"
	tput cnorm
	exit 1
}



tput civis

echo -e "\n${yellowColour}[+]${endColour} ${blueColour}Installing container...${endColour}\n"

mkdir -p docker/workspace


if(cd docker &>"$log" && sudo docker compose up -d --build &>"$log"); then
  echo -e "\n${greenColour}[+]${endColour} ${greenColour}Done${endColour}\n";
  rm -f "$log"
  tput cnorm
  exit 0

else
  echo -e "\n${redColour}[!]${endColour}${redColour} Error Installing container${endColour}\n"
  echo -e "\n${yellowColour}Last long lines (full log: $log):${endColour}\n"
  tail -n 20 "$log"
  tput cnorm
  exit 2
fi
