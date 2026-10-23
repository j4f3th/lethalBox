#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"
grayColour="\e[0;37m\033[1m"

log=$(mktemp)

function ctrl_c(){
    echo -e "\n\n${yellowColour}[*]${endColour}${grayColour}\t Exiting... ${endColour}\n"
    tput cnorm
    rm -f "$log"
    exit 1
}

trap ctrl_c INT

sudo -v

tput civis

echo -e "\n${yellowColour}[+]${endColour}${grayColour} Cleaning...${endColour}\n"

if (
    cd docker
    sudo docker compose down -v --rmi all --remove-orphans
    sudo docker rm -f code-lab || true
    sudo docker rmi -f code-lab:debian || true
    sudo rm -rf workspace
) &>"$log"; then
    echo -e "\n${greenColour}[+] Cleaned${endColour}\n"
    rm -f "$log"
    tput cnorm
    exit 0
else
    echo -e "\n${redColour}[!] Error cleaning docker...${endColour}\n"
    echo -e "${yellowColour}Last log lines (full log: $log)${endColour}\n"
    tail -n 20 "$log"
    tput cnorm
    exit 2
fi
