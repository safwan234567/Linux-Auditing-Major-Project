#! /bin/bash

#Workstation level 1

RED="\e[91m"
GREEN="\e[92m"
ENDCOLOR="\e[0m"

passno=00
failno=00

echo 3.1 Network Parameters Host Only
echo 3.1.1 Ensure IP forwarding is disabled
#3.1.1
ipv4forwardcheck=$(sysctl net.ipv4.ip_forward)
ipv6allforwardcheck=$(sysctl net.ipv6.conf.all.forwarding)
        if [[ $ipv4forwardcheck == 'net.ipv4.ip_forward = 0' ]] && [[ $ipv6allforwardcheck == 'net.ipv6.conf.all.forwarding = 0' ]]
        then
                echo -e "${GREEN}Pass:  IP forwarding is disabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    IP forwarding is not disabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.1.2 Ensure packet redirect sending is disabled
#3.1.2
ipv4allredirectcheck=$(sysctl net.ipv4.conf.all.send_redirects)
ipv4defaultredirectcheck=$(sysctl net.ipv4.conf.default.send_redirects)
        if [[ $ipv4allredirectcheck == 'net.ipv4.conf.all.send_redirects = 0' ]] && [[ $ipv4defaultredirectcheck == 'net.ipv4.conf.default.send_redirects = 0' ]]
        then
                echo -e "${GREEN}Pass:  Packet redirect sending is disabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    Packet redirect sending is not disabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2 Network Parameters Host and Router
echo 3.2.1 Ensure source routed packets are not accepted
#3.2.1
ipv4allroutecheck=$(sysctl net.ipv4.conf.all.accept_source_route)
ipv4defaultroutecheck=$(sysctl net.ipv4.conf.default.accept_source_route)
ipv6allroutecheck=$(sysctl net.ipv6.conf.all.accept_source_route)
ipv6defaultroutecheck=$(sysctl net.ipv6.conf.default.accept_source_route)
        if [[ $ipv4allroutecheck == 'net.ipv4.conf.all.accept_source_route = 0' ]] && [[ $ipv4defaultroutecheck == 'net.ipv4.conf.default.accept_source_route = 0' ]] && [[ $ipv6allroutecheck == 'net.ipv6.conf.all.accept_source_route = 0' ]] && [[$ip6defaultroutecheck == 'net.ipv6.conf.default.accept_source_route = 0' ]]
        then
                echo -e "${GREEN}Pass:  Source routed packets are not accepted
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    Source routed packets are accepted
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.2 Ensure ICMP redirects are not accepted
#3.2.2
ipv4icmpracheck=$(sysctl net.ipv4.conf.all.accept_redirects)
ipv4icmprdcheck=$(sysctl net.ipv4.conf.default.accept_redirects)
ipv6icmpracheck=$(sysctl net.ipv6.conf.all.accept_redirects)
ipv6icmprdcheck=$(sysctl net.ipv6.conf.default.accept_redirects)

        if [[ $ipv4icmpracheck == 'net.ipv4.conf.all.accept_redirects = 0' ]] && [[ $ipv4icmprdcheck == 'net.ipv4.conf.default.accept_redirects = 0' ]] && [[ $ipv6icmpracheck == 'net.ipv6.conf.all.accept_redirects = 0' ]] && [[ $ipv6icmprdcheck == 'net.ipv6.conf.default.accept_redirects = 0' ]]
        then
                echo -e "${GREEN}Pass:  ICMP redirects are not accepted
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    ICMP redirects are accepted
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.3 Ensure secure ICMP redirects are not accepted
#3.2.3
secureaicmpcheck=$(sysctl net.ipv4.conf.all.secure_redirects)
securedicmpcheck=$(sysctl net.ipv4.conf.default.secure_redirects)
        if [[ $secureaicmpcheck == 'net.ipv4.conf.all.accept_redirects = 0' ]] && [[ $securedicmpcheck == 'net.ipv4.conf.default.accept_redirects = 0' ]]
        then
                echo -e "${GREEN}Pass:  Secure ICMP redirects are not accepted
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    Secure ICMP redirects are accepted
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.4 Ensure suspicious packets are logged
#3.2.4
packetlogacheck=$(sysctl net.ipv4.conf.all.log_martians)
packetlogdcheck=$(sysctl net.ipv4.conf.default.log_martians)
        if [[ $packetlogacheck == 'net.ipv4.conf.all.log_martians = 1' ]] && [[ $packetlogdcheck == 'net.ipv4.conf.default.log_martians = 1' ]]
        then
                echo -e "${GREEN}Pass:  Suspicious packets are logged
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    Suspicious packets are not logged
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.5 Ensure broadcast ICMP requests are ignored
#3.2.5
broadcasticmpcheck=$(sysctl net.ipv4.icmp_echo_ignore_broadcasts)
        if [[ $broadcasticmpcheck == 'net.ipv4.icmp_echo_ignore_broadcasts = 1' ]]
        then
                echo -e "${GREEN}Pass:  Broadcast ICMP requests are ignored
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    Broadcast ICMP requests are not ignored
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.6 Ensure bogus ICMP responses are ignored
#3.2.6
icmpboguscheck=$(sysctl net.ipv4.icmp_ignore_bogus_error_responses)
        if [[ $icmpboguscheck == 'net.ipv4.icmp_ignore_bogus_error_responses = 1' ]]
        then
                echo -e "${GREEN}Pass:  Bogus ICMP responses are ignored
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    Bogus ICMP responses are not ignored
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.7 Ensure Reverse Path Filtering is enabled
#3.2.7
reversepathafilter=$(sysctl net.ipv4.conf.all.rp_filter)
reversepathdfilter=$(sysctl net.ipv4.conf.default.rp_filter)
        if [[ $reversepathafilter == 'net.ipv4.conf.all.rp_filter = 1' ]] && [[ $reversepathdfilter == 'net.ipv4.conf.default.rp_filter = 1' ]]
        then
                echo -e "${GREEN}Pass:  Reverse Path Filtering is enabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    Reverse Path Filtering is not enabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.8 Ensure TCP SYN Cookies is enabled
#3.2.8
syncookies=$(sysctl net.ipv4.tcp_syncookies)
        if [[ $syncookies == 'net.ipv4.tcp_syncookies = 1' ]]
        then
                echo -e "${GREEN}Pass:  TCP SYN Cookies is enabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    TCP SYN Cookies is not enabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.9 Ensure IPv6 router advertisements are not accepted
#3.2.9
routeradda=$(sysctl net.ipv6.conf.all.accept_ra)
routeraddd=$(sysctl net.ipv6.conf.default.accept_ra)
        if [[ $routeradda == 'net.ipv6.conf.all.accept_ra = 0' ]] && [[ $routeraddd == 'net.ipv6.conf.default.accept_ra = 0' ]]
        then
                echo -e "${GREEN}Pass:  IPv6 router advertisements are not accepted
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    IPv6 router advertisements are accepted
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.4 Firewall Configuration

echo 3.4.1 Ensure Firewall Software is installed
echo 3.4.1.1 Ensure a Firewall package is installed
#3.4.1.1
firewalld=$(rpm -q firewalld)
nftables=$(rpm -q nftables)
iptables=$(rpm -q iptables)
        if [[ $firewalld == 'package firewalld is not installed' ]]
        then
                echo -e "${RED}Fail:    No firewall package is installed
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        elif [[ $nftables == 'package nftables is not installed' ]]
        then
                echo -e "${RED}Fail:    No firewall pacakge is installed
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        elif [[ $iptables == 'package iptables is no installed' ]]
        then
                echo -e "${RED}Fail:    No firewall package is installed
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:  A firewall package is installed
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        fi


echo 3.4.2 Configure firewalld
echo 3.4.2.1 Ensure firewalld service is enabled and running
#3.4.2.1
firewallrunning=$(firewall-cmd --state)
        if [[ `systemctl is-enabled firewalld 2>/dev/null`  == 'enabled' ]] && [[ $firewallrunning == 'running' ]]
        then
                echo -e "${GREEN}Pass:  firewalld service is enabled and running
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    firewalld service is not enabled and not running
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.4.2.2 Ensure nftables is not enabled
#3.4.2.2
        if [[ `systemctl is-enabled nftables 2>/dev/null`  == 'disabled' || 'masked' ]]
        then
                echo -e "${GREEN}Pass:  nftables is not enabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    nftables is enabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.4.2.3 Ensure default zone is set
#3.4.2.3
defaultzone=$(firewall-cmd --get-default-zone)
        if [[ $defaultzone == 'public' ]]
        then
                echo -e "${GREEN}Pass:  Default zone is set
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    Default zone is not set
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.4.2.4 Ensure network interfaces are assigned to appropriate zone
#3.4.2.4



echo incomplete 3.4.2.4


echo 3.4.2.5 Ensure unnecessary services and ports are not accepted
#3.4.2.5



echo incomplete 3.4.2.5


echo 3.4.2.6 Ensure iptables is not enabled
#3.4.2.6
        if [[ `systemctl is-enabled iptables 2>/dev/null`  == 'disabled' ]]
        then
                echo -e "${GREEN}Pass:  iptables is not enabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    iptables is enabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.4.3 Configure nftables
echo 3.4.3.1 Ensure iptables are flushed
#3.4.3.1
        if [[ -n `iptables -L` ]] && [[ -n `ip6tables -L` ]]
        then
                echo -e "${GREEN}Pass:  iptables are flushed
                ${ENDCOLOR}"
                passno=$(($passno + 1))

        else
                echo -e "${RED}Fail:    iptables are not flushed
                ${ENDCOLOR}"
                failno=$(($failno + 1))

        fi


echo 3.4.3.2 Ensure a table exists
#3.4.3.2
tableexist=$(nft list tables)
        if [[ -n $tableexist ]]
        then
                echo -e "${GREEN}Pass:  A table exists
                ${ENDCOLOR}"
                passno=$(($passno + 1))

        else
                echo -e "${RED}Fail:    No table exists
                ${ENDCOLOR}"
                failno=$(($failno + 1))

        fi


echo 3.4.3.3 Ensure base chains exist
#3.4.3.3
#Unsure about this one, pretty sure its wrong.
if [[ `nft list ruleset | grep 'hook input' 2>/dev/null` == 'type filter hook input priority 0;' ]] && [[ `nft list ruleset | grep 'hook forward' 2>/dev/null` == 'type filter hook forward priority 0;' ]] && [[ `nft list ruleset | grep 'hook output' 2>/dev/null` == 'type filter hook output priority 0;' ]]

        then
                echo -e "${GREEN}Pass:  base chains exists
                ${ENDCOLOR}"
                passno=$(($passno + 1))

        else
                echo -e "${RED}Fail:    base chains do not exists
                ${ENDCOLOR}"
                failno=$(($failno + 1))

        fi


echo 3.4.3.4 Ensure loopback traffic is configured
#3.4.3.4
loaccept=$(nft list ruleset | awk '/hook input/,/}/' | grep 'iif "lo" accept')
ipsddr=$(nft list ruleset | awk '/hook input/,/}/' | grep 'ip sddr')
ip6ssdr=$(nft list ruleset | awk '/hook input/,/}/' | grep 'ip6 saddr')
        if [[ -z $loaccept ]] && [[ -z $ipsddr ]] && [[ -z $ip6ssdr ]]
        then
                echo -e "${RED}Fail:    loopback traffic is not configured
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:  loopback traffic is configured
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        fi


echo 3.4.3.5 Ensure outbound and established connections are configured
#3.4.3.5
outboundconf=$(nft list ruleset | awk '/hook input/,/}/' | grep -E 'ip protocol (tcp|udp|icmp) ct state')
        if [[ `$outboundconf 2>/dev/null`  == 'ip protocol tcp ct state established accept' ]] && [[ `$outboundconf 2>/dev/null` == 'ip protocol udp ct state established accept' ]] && [[ `$outboundconf 2>/dev/null` == 'ip protocol icmp ct state established accept' ]]
        then
                echo -e "${GREEN}Pass:  outbound and established connections are configured
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    outbound and established connections are not configured
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.4.3.6 Ensure default deny firewall policy
#3.4.3.6
if [[ `nft list ruleset | grep 'hook input' 2>/dev/null` == 'type filter hook input priority 0; policy drop;' ]] && [[ `nft list ruleset | grep 'hook forward' 2>/dev/null` == 'type filter hook forward priority 0; policy drop;' ]] && [[ `nft list ruleset | grep 'hook output' 2>/dev/null` == 'type filter hook output priority 0; policy drop;' ]]
        then
                echo -e "${GREEN}Pass:  default firewall policy is deny
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    default firewall policy is not deny
                ${ENDCOLOR}"
                failno=$(($failno + 1))

        fi


echo 3.4.3.7 Ensure nftables service is eabled
#3.4.3.7
        if [[ `systemctl is-enabled nftables 2>/dev/null` == 'enabled' ]]
        then
                echo -e "${GREEN}Pass:  nftables service is enabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    nftables service is not enabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.4.3.8 Ensure nftables rules are permanent
#3.4.3.8
echo 3.4.3.8 Unsure how to do


echo 3.4.4 Configure iptables
echo 3.4.4.1 Configure IPv4 iptables
echo 3.4.4.1.1 Ensure default deny firewall policy
#3.4.4.1.1
        if [[ `iptables -L 2>/dev/null` == 'Chain INPUT (policy DROP)' ]] && [[ `iptables -L 2>/dev/null` == 'Chain FORWARD (policy Drop)' ]] && [[ `iptables -L 2>/dev/null` == 'Chain OUTPUT (policy DROP)' ]]
        then
                echo -e "${GREEN}Pass:  default firewall policy is deny
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:    default firewall policy is not deny
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.4.4.1.2 Ensure loopback traffic is configured
#3.4.4.1.2
#Unsure How to do
echo 3.4.4.1.2 Unsure how to do

echo 3.4.4.1.3 Ensure outbound and established connections are configured
#3.4.4.1.3
#Unsure How to do
echo 3.4.4.1.3 Unsure how to do

echo 3.4.4.1.4 Ensure firewall rule exists for all open ports
#3.4.4.1.4
#Unsure How to do
echo 3.4.4.1.4 Unsure how to do


echo 3.4.4.2 Configure IPv6 ip6tables
echo 3.4.4.2.1 Ensure IPv6 default deny firewall policy
#3.4.4.2.1
#Unsure How to do
echo 3.4.4.2.1 Unsure how to do

echo 3.4.4.2.2 Ensure IPv6 loopback traffic is configured
#3.4.4.2.2
#Unsure How to do
echo 3.4.4.2.2 Unsure how to do


echo 3.4.4.2.3 Ensure IPv6 outbound and established connections are not configured
#3.4.4.2.3
#Unsure How to do
echo 3.4.4.2.3 Unsure how to do

echo 3.4.4.2.4 Ensure IPv6 firewall rules exist for all open ports
#3.4.4.2.4
#Unsure how to do
echo 3.4.4.2 Unsure how to do


echo Number of Passes:  $passno
echo Number of Failed:  $failno

