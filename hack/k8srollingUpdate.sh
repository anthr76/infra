#!/bin/bash

# This is a hack until auto updates with Zincati is supported.
# This can be smarter using Kubectl etc but at this point Zincati might
# Actually work but I don't have the time to figure that out currently.

hosts=(
    "worker-01.scr1.rabbito.tech"
    "worker-02.scr1.rabbito.tech"
    "worker-03.scr1.rabbito.tech"
    "worker-13.scr1.rabbito.tech"
    "worker-14.scr1.rabbito.tech"
)

Color_Off='\033[0m' # Text Reset
Black='\033[0;30m'  # Black
Red='\033[0;31m'    # Red
Green='\033[0;32m'  # Green

for i in "${hosts[@]}"; do
    echo -e ${Green} Starting "$i" ${Color_Off}
    ssh -l core "$i" 'sudo rpm-ostree upgrade -r; exit'
    sleep 15
    while ! timeout 0.2 ping -c 1 -n "$i" &>/dev/null; do
        printf "%c" "."
    done
    printf "\n%s\n" "Server is back online"

done
