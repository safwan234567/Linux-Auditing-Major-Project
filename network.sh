#! /bin/bash

RED="\e[91m"
GREEN="\e[92m"
ENDCOLOR="\e[0m"

passno=00
failno=00
echo
echo
echo 3.1 Network Parameters Host Only
echo
#3.1.1
ipv4forwardcheck=$(sysctl net.ipv4.ip_forward)
ipv6allforwardcheck=$(sysctl net.ipv6.conf.all.forwarding)
	if [[ $ipv4forwardcheck == 'net.ipv4.ip_forward = 0' ]] && [[ $ipv6allforwardcheck == 'net.ipv6.conf.all.forwarding = 0' ]]
	then
		echo -e "${GREEN}Pass:	3.1.1 Ensure IP forwarding is disabled
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.1.1 Ensure IP forwarding is disabled
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi
echo
echo
#3.1.2
ipv4allredirectcheck=$(sysctl net.ipv4.conf.all.send_redirects)
ipv4defaultredirectcheck=$(sysctl net.ipv4.conf.default.send_redirects)
	if [[ $ipv4allredirectcheck == 'net.ipv4.conf.all.send_redirects = 0' ]] && [[ $ipv4defaultredirectcheck == 'net.ipv4.conf.default.send_redirects = 0' ]]
	then 
		echo -e "${GREEN}Pass:	3.1.2 Ensure packet redirect sending is disabled
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.1.2 Ensure packet redirect sending is disabled
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi
echo
echo
echo 3.2 Network Parameters Host and Router
echo
#3.2.1
ipv4allroutecheck=$(sysctl net.ipv4.conf.all.accept_source_route)
ipv4defaultroutecheck=$(sysctl net.ipv4.conf.default.accept_source_route)
ipv6allroutecheck=$(sysctl net.ipv6.conf.all.accept_source_route)
ipv6defaultroutecheck=$(sysctl net.ipv6.conf.default.accept_source_route)
	if [[ $ipv4allroutecheck == 'net.ipv4.conf.all.accept_source_route = 0' ]] && [[ $ipv4defaultroutecheck == 'net.ipv4.conf.default.accept_source_route = 0' ]] && [[ $ipv6allroutecheck == 'net.ipv6.conf.all.accept_source_route = 0' ]] && [[$ip6defaultroutecheck == 'net.ipv6.conf.default.accept_source_route = 0' ]]
	then
		echo -e "${GREEN}Pass:	3.2.1 Ensure source routed packets are not accepted
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.2.1 Ensure source routed packets are not accepted
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi
echo
echo
#3.2.2
ipv4icmpracheck=$(sysctl net.ipv4.conf.all.accept_redirects)
ipv4icmprdcheck=$(sysctl net.ipv4.conf.default.accept_redirects)
ipv6icmpracheck=$(sysctl net.ipv6.conf.all.accept_redirects)
ipv6icmprdcheck=$(sysctl net.ipv6.conf.default.accept_redirects)

	if [[ $ipv4icmpracheck == 'net.ipv4.conf.all.accept_redirects = 0' ]] && [[ $ipv4icmprdcheck == 'net.ipv4.conf.default.accept_redirects = 0' ]] && [[ $ipv6icmpracheck == 'net.ipv6.conf.all.accept_redirects = 0' ]] && [[ $ipv6icmprdcheck == 'net.ipv6.conf.default.accept_redirects = 0' ]]
	then
		echo -e "${GREEN}Pass:	3.2.2 Ensure ICMP redirects are not accepted
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.2.2 Ensure ICMP redirects are not accepted
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi
echo
echo
#3.2.3
secureaicmpcheck=$(sysctl net.ipv4.conf.all.secure_redirects)
securedicmpcheck=$(sysctl net.ipv4.conf.default.secure_redirects)
	if [[ $secureaicmpcheck == 'net.ipv4.conf.all.accept_redirects = 0' ]] && [[ $securedicmpcheck == 'net.ipv4.conf.default.accept_redirects = 0' ]]
	then
		echo -e "${GREEN}Pass:	3.2.3 Ensure secure ICMP redirects are not accepted
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.2.3 Ensure secure ICMP redirects are not accepted
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi

echo
echo
#3.2.4
packetlogacheck=$(sysctl net.ipv4.conf.all.log_martians)
packetlogdcheck=$(sysctl net.ipv4.conf.default.log_martians)
	if [[ $packetlogacheck == 'net.ipv4.conf.all.log_martians = 1' ]] && [[ $packetlogdcheck == 'net.ipv4.conf.default.log_martians = 1' ]] 
	then
		echo -e "${GREEN}Pass:	3.2.4 Ensure suspicious packets are logged
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.2.4 Ensure suspicious packets are logged
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi

echo
echo
#3.2.5
broadcasticmpcheck=$(sysctl net.ipv4.icmp_echo_ignore_broadcasts)
	if [[ $broadcasticmpcheck == 'net.ipv4.icmp_echo_ignore_broadcasts = 1' ]]
	then
		echo -e "${GREEN}Pass:	3.2.5 Ensure broadcast ICMP requests are ignored
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.2.5 Ensure broadcast ICMP requests are ignored
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi

echo
echo
#3.2.6
icmpboguscheck=$(sysctl net.ipv4.icmp_ignore_bogus_error_responses)
	if [[ $icmpboguscheck == 'net.ipv4.icmp_ignore_bogus_error_responses = 1' ]]
	then
		echo -e "${GREEN}Pass:	3.2.6 Ensure bogus ICMP responses are ignored
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.2.6 Ensure bogus ICMP responses are ignored
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi

echo
echo
#3.2.7
reversepathafilter=$(sysctl net.ipv4.conf.all.rp_filter)
reversepathdfilter=$(sysctl net.ipv4.conf.default.rp_filter)
	if [[ $reversepathafilter == 'net.ipv4.conf.all.rp_filter = 1' ]] && [[ $reversepathdfilter == 'net.ipv4.conf.default.rp_filter = 1' ]] 
	then
		echo -e "${GREEN}Pass:	3.2.7 Ensure Reverse Path Filtering is enabled
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.2.7 Ensure Reverse Path Filtering is enabled
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi

echo
echo
#3.2.8
syncookies=$(sysctl net.ipv4.tcp_syncookies)
	if [[ $syncookies == 'net.ipv4.tcp_syncookies = 1' ]] 
	then 
		echo -e "${GREEN}Pass:	3.2.8 Ensure TCP SYN Cookies is enabled
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.2.8 Ensure TCP SYN Cookies is enabled
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi

echo
echo
#3.2.9
routeradda=$(sysctl net.ipv6.conf.all.accept_ra)
routeraddd=$(sysctl net.ipv6.conf.default.accept_ra)
	if [[ $routeradda == 'net.ipv6.conf.all.accept_ra = 0' ]] && [[ $routeraddd == 'net.ipv6.conf.default.accept_ra = 0' ]]
	then 
		echo -e "${GREEN}Pass:	3.2.9 Ensure IPv6 router advertisements are not accepted
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.2.9 Ensure IPv6 router advertisements are not accepted
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi

echo
echo
echo 3.3 Uncommon Network Protocols
echo
#3.3.1
if ! modprobe -n -v dccp 2> /dev/null | tail -1 | grep -q 'install /bin/true'
	then
		echo -e "${RED}Fail:	3.3.1 Ensure DCCP is disabled
		${ENDCOLOR}"
		failno=$(($failno + 1))
	else
		echo -e "${GREEN}Pass:	3.3.1 Ensure DCCP is disabled
		${ENDCOLOR}"
		passno=$(($passno + 1))
	fi

echo
echo
#3.3.2
if ! modprobe -n -v sctp 2> /dev/null | tail -1 | grep -q 'install /bin/true'
	then
		echo -e "${RED}Fail:	3.3.2 Ensure SCTP is disabled
		${ENDCOLOR}"
		failno=$(($failno + 1))
	else
		echo -e "${GREEN}Pass:	3.3.2 Ensure SCTP is disabled
		${ENDCOLOR}"
		passno=$(($passno + 1))
	fi

echo
echo
#3.3.3
if ! modprobe -n -v rds 2> /dev/null | tail -1 | grep -q 'install /bin/true'
        then
                echo -e "${RED}Fail:	3.3.3 Ensure RDS is disabled
                ${ENDCOLOR}"
		failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:	3.3.3 Ensure RDS is disabled
                ${ENDCOLOR}"
		passno=$(($passno + 1))
        fi

echo
echo
#3.3.4
if ! modprobe -n -v tipc 2> /dev/null | tail -1 | grep -q 'install /bin/true'
        then
                echo -e "${RED}Fail:	3.3.4 Ensure TIPC is disabled
                ${ENDCOLOR}"
		failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:	3.3.4 Ensure TIPC is disabled
                ${ENDCOLOR}"
		passno=$(($passno + 1))
        fi

echo
echo
echo 3.4 Firewall Configuration
echo
echo 3.4.1 Ensure Firewall Software is installed
echo
#3.4.1.1
firewalld=$(rpm -q firewalld)
nftables=$(rpm -q nftables)
iptables=$(rpm -q iptables)
	if [[ $firewalld == 'package firewalld is not installed' ]]
	then
		echo -e "${RED}Fail:	3.4.1.1 Ensure a Firewall package is installed
		${ENDCOLOR}"
		failno=$(($failno + 1))
	elif [[ $nftables == 'package nftables is not installed' ]]
	then
		echo -e "${RED}Fail:	3.4.1.1 Ensure a Firewall package is installed
		${ENDCOLOR}"
		failno=$(($failno + 1))
	elif [[ $iptables == 'package iptables is no installed' ]]
	then
		echo -e "${RED}Fail:	3.4.1.1 Ensure a Firewall package is installed
		${ENDCOLOR}"
		failno=$(($failno + 1))
	else
		echo -e "${GREEN}Pass:	3.4.1.1 Ensure a Firewall package is installed
		${ENDCOLOR}"
		passno=$(($passno + 1))
	fi

echo
echo
echo 3.4.2 Configure firewalld
echo
#3.4.2.1
firewallrunning=$(firewall-cmd --state)
	if [[ `systemctl is-enabled firewalld 2>/dev/null`  == 'enabled' ]] && [[ $firewallrunning == 'running' ]]
	then
		echo -e "${GREEN}Pass:	3.4.2.1 Ensure firewalld service is enabled and running
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.4.2.1 Ensure firewalld service is enabled and running
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi

echo
echo
#3.4.2.2
	if [[ `systemctl is-enabled nftables 2>/dev/null`  == 'disabled' || 'masked' ]]
	then
		echo -e "${GREEN}Pass:	3.4.2.2 Ensure nftables is not enabled
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.4.2.2 Ensure nftables is not enabled
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi
	
echo
echo
#3.4.2.3
defaultzone=$(firewall-cmd --get-default-zone)
	if [[ $defaultzone == 'public' ]] 
	then
		echo -e "${GREEN}Pass:	3.4.2.3 Ensure default zone is set
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.4.2.3 Ensure default zone is set
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi

echo
echo
#3.4.2.4



echo incomplete 3.4.2.4

echo
echo
#3.4.2.5



echo incomplete 3.4.2.5

echo
echo
#3.4.2.6
	if [[ `systemctl is-enabled iptables 2>/dev/null`  == 'disabled' ]]
	then
		echo -e "${GREEN}Pass:	3.4.2.6 Ensure iptables is not enabled
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else 
		echo -e "${RED}Fail:	3.4.2.6 Ensure iptables is not enabled
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi

echo
echo
echo 3.4.3 Configure nftables
echo
#3.4.3.1
	if [[ -n `iptables -L` ]] && [[ -n `ip6tables -L` ]]
	then
		echo -e "${GREEN}Pass:	3.4.3.1 Ensure iptables are flushed
		${ENDCOLOR}"
		passno=$(($passno + 1))
		
	else
		echo -e "${RED}Fail:	3.4.3.1 Ensure iptables are flushed
		${ENDCOLOR}"
		failno=$(($failno + 1))
		
	fi



echo
echo
#3.4.3.2
tableexist=$(nft list tables)
	if [[ -n $tableexist ]] 
	then
		echo -e "${GREEN}Pass:	3.4.3.2 Ensure a table exists
		${ENDCOLOR}"
		passno=$(($passno + 1))
		
	else
		echo -e "${RED}Fail:	3.4.3.2 Ensure a table exists
		${ENDCOLOR}"
		failno=$(($failno + 1))
		
	fi

echo
echo
#3.4.3.3
#Unsure about this one, pretty sure its wrong.
if [[ `nft list ruleset | grep 'hook input' 2>/dev/null` == 'type filter hook input priority 0;' ]] && [[ `nft list ruleset | grep 'hook forward' 2>/dev/null` == 'type filter hook forward priority 0;' ]] && [[ `nft list ruleset | grep 'hook output' 2>/dev/null` == 'type filter hook output priority 0;' ]]

	then
		echo -e "${GREEN}Pass:	3.4.3.3 Ensure base chains exists
		${ENDCOLOR}"
		passno=$(($passno + 1))
		
	else
		echo -e "${RED}Fail:	3.4.3.3 Ensure base chains exists
		${ENDCOLOR}"
		failno=$(($failno + 1))
		
	fi

echo
echo
#3.4.3.4
loaccept=$(nft list ruleset | awk '/hook input/,/}/' | grep 'iif "lo" accept')
ipsddr=$(nft list ruleset | awk '/hook input/,/}/' | grep 'ip sddr')
ip6ssdr=$(nft list ruleset | awk '/hook input/,/}/' | grep 'ip6 saddr')
	if [[ -z $loaccept ]] && [[ -z $ipsddr ]] && [[ -z $ip6ssdr ]]
	then
		echo -e "${RED}Fail:	3.4.3.4 Ensure loopback traffic is configured
		${ENDCOLOR}"
		failno=$(($failno + 1))
	else
		echo -e "${GREEN}Pass:	3.4.3.4 Ensure loopback traffic is configured
		${ENDCOLOR}"
		passno=$(($passno + 1))
	fi

echo
echo
#3.4.3.5
outboundconf=$(nft list ruleset | awk '/hook input/,/}/' | grep -E 'ip protocol (tcp|udp|icmp) ct state')
	if [[ `$outboundconf 2>/dev/null`  == 'ip protocol tcp ct state established accept' ]] && [[ `$outboundconf 2>/dev/null` == 'ip protocol udp ct state established accept' ]] && [[ `$outboundconf 2>/dev/null` == 'ip protocol icmp ct state established accept' ]]
	then
		echo -e "${GREEN}Pass:	3.4.3.5 Ensure outbound and established connections are configured
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.4.3.5 Ensure outbound and established connections are configured
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi

echo
echo
#3.4.3.6
if [[ `nft list ruleset | grep 'hook input' 2>/dev/null` == 'type filter hook input priority 0; policy drop;' ]] && [[ `nft list ruleset | grep 'hook forward' 2>/dev/null` == 'type filter hook forward priority 0; policy drop;' ]] && [[ `nft list ruleset | grep 'hook output' 2>/dev/null` == 'type filter hook output priority 0; policy drop;' ]]
        then
                echo -e "${GREEN}Pass:	3.4.3.6 Ensure default deny firewall policy
                ${ENDCOLOR}"
		passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	3.4.3.6 Ensure default deny firewall policy
                ${ENDCOLOR}"
		failno=$(($failno + 1))

        fi

echo
echo
#3.4.3.7
	if [[ `systemctl is-enabled nftables 2>/dev/null` == 'enabled' ]]
	then
		echo -e "${GREEN}Pass:	3.4.3.7 Ensure nftables service is enabled
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.4.3.7 Ensure nftables service is enabled
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi

echo
echo
#3.4.3.8
echo 3.4.3.8 Unsure how to do
echo
echo
echo 3.4.4 Configure iptables
echo 3.4.4.1 Configure IPv4 iptables
#3.4.4.1.1
	if [[ `iptables -L 2>/dev/null` == 'Chain INPUT (policy DROP)' ]] && [[ `iptables -L 2>/dev/null` == 'Chain FORWARD (policy Drop)' ]] && [[ `iptables -L 2>/dev/null` == 'Chain OUTPUT (policy DROP)' ]]
	then
		echo -e "${GREEN}Pass:	3.4.4.1.1 Ensure default deny firewall policy
		${ENDCOLOR}"
		passno=$(($passno + 1))
	else
		echo -e "${RED}Fail:	3.4.4.1.1 Ensure default deny firewall policy
		${ENDCOLOR}"
		failno=$(($failno + 1))
	fi

echo
echo
#3.4.4.1.2
#Unsure How to do
echo 3.4.4.1.2 Unsure how to do
echo
echo
#3.4.4.1.3
#Unsure How to do
echo 3.4.4.1.3 Unsure how to do
echo
echo
#3.4.4.1.4
#Unsure How to do
echo 3.4.4.1.4 Unsure how to do
echo
echo
echo 3.4.4.2 Configure IPv6 ip6tables
echo
#3.4.4.2.1
#Unsure How to do
echo 3.4.4.2.1 Unsure how to do
echo
echo
#3.4.4.2.2
#Unsure How to do
echo 3.4.4.2.2 Unsure how to do
echo
echo
#3.4.4.2.3
#Unsure How to do
echo 3.4.4.2.2 Unsure how to do
echo
echo
#3.4.4.2.4
#Unsure how to do
echo 3.4.4.2 Unsure how to do
echo
echo
#3.5
wirelesscheck=$(nmcli radio all)
#unsure
echo 3.5 Unsure how to do
echo
echo
#3.6
ipv6disable=$(grep -E "^\s*kernelopts=(\S+\s+)*ipv6\.disable=1\b\s*(\S+\s*)*$" /boot/grub2/grubenv)
	if [[ -z $ipv6disable ]] 
	then
		echo -e "${RED}Fail:	3.6 Disable IPv6
		${ENDCOLOR}"
		failno=$(($failno + 1))
	else
		echo -e "${GREEN}Pass:	3.6 Disable IPv6
		${ENDCOLOR}"
		passno=$(($passno + 1))
	fi

echo
echo
echo Number of Passes:	$passno
echo Number of Failed:	$failno
