#! /bin/bash

#Server Level 2

RED="\e[91m"
GREEN="\e[92m"
ENDCOLOR="\e[0m"

passno=00
failno=00

echo 3.3 Uncommon Network Protocols
echo 3.3.1 Ensure DCCP is disabled
#3.3.1
if ! modprobe -n -v dccp 2> /dev/null | tail -1 | grep -q 'install /bin/true'
        then
                echo -e "${RED}Fail:    DCCP is not disabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:  DCCP is disabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        fi


echo 3.3.2 Ensure SCTP is disabled
#3.3.2
if ! modprobe -n -v sctp 2> /dev/null | tail -1 | grep -q 'install /bin/true'
        then
                echo -e "${RED}Fail:    SCTP is not disabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:  SCTP is disabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        fi


echo 3.3.3 Ensure RDS is disabled
#3.3.3
if ! modprobe -n -v rds 2> /dev/null | tail -1 | grep -q 'install /bin/true'
        then
                echo -e "${RED}Fail:    RDS is not disabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:  RDS is disabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        fi


echo 3.3.4 Ensure TIPC is disabled
#3.3.4
if ! modprobe -n -v tipc 2> /dev/null | tail -1 | grep -q 'install /bin/true'
        then
                echo -e "${RED}Fail:    TIPC is not disabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:  TIPC is disabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        fi


echo 3.6 Disable IPv6
#3.6
ipv6disable=$(grep -E "^\s*kernelopts=(\S+\s+)*ipv6\.disable=1\b\s*(\S+\s*)*$" /boot/grub2/grubenv)
        if [[ -z $ipv6disable ]]
        then
                echo -e "${RED}Fail:    IPv6 is not disabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:  IPv6 is disabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        fi



echo Number of Passes:  $passno
echo Number of Failed:  $failno

