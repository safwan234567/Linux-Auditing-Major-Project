#! /bin/bash

passno=0
failno=0
RED="\e[91m"
GREEN="\e[92m"
ENDCOLOR="\e[0m"

echo CHAPTER 1 : INITIAL SETUP
echo
echo "1.1.1.1: Ensure mounting of cramfs filesystems is disabled" 
if [[ `modprobe -n -v cramfs` != "install /bin/true" ]]
        then
            	echo -e "${RED}Fail:	Cramfs is not disabled${ENDCOLOR}"
                failno=$(($failno + 1))

elif [[ -n `lsmod | grep cramfs` ]]
                then
                    	echo -e "${RED}Fail:	Cramfs is not disabled${ENDCOLOR}"
                        failno=$(($failno + 1))

else
    	echo -e "${GREEN}Pass:	Cramfs is disabled${ENDCOLOR}"
        passno=$(($passno + 1))
fi #something went wrong here

echo"1.1.1.3: Ensure mounting of squashfs filesystems is disabled"
if [[ `modprobe -n -v squashfs` != "install /bin/true" ]]
 
       then
           	echo -e "${RED}Fail:	squashfs filesystems is not disabled${ENDCOLOR}"
                failno=$(($failno + 1))

elif [[ -n `lsmod | grep squashfs` ]]
                then
                        echo -e "${RED}Fail:	squashfs filesystems is not disabled${ENDCOLOR}"
                        failno=$(($failno + 1))
else
        echo -e "${GREEN}Pass:	squashfs filesystems are configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi #something went wrong here

echo "1.1.1.4 Ensure mounting of udf filesystems is disabled"
if [[ `modprobe -n -v udf` != "install /bin/true" ]]
        then
           	echo -e "${RED}Fail:	udf filesystems are not disabled${ENDCOLOR}"
                failno=$(($failno + 1))

elif [[ -n `lsmod | grep udf` ]]
                then
                    	echo -e  "${RED}Fail:	udf filesystems are not disabled${ENDCOLOR}"
                        failno=$(($failno + 1))

else
        echo -e "${GREEN}Pass:	udf filesystems are configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi #something went wrong here

echo "1.1.2 Ensure /tmp is configured"
if [[ -z `mount | grep -E '\s/tmp\s'` ]]
        then
            	echo -e "${RED}Fail:	/tmp is not configured properly${ENDCOLOR}"
                failno=$(($failno + 1))
elif [[ -z `grep -E '\s/tmp\s' /etc/fstab | grep -E -v '^\s*#'` ]]
        then
            	echo -e "${RED}Fail:	/tmp is not configured properly${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo -e "${GREEN}Pass:	/tmp is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.3 Ensure nodev option set on /tmp partition" 
if [[ -n `mount | grep -E '\s/tmp\s' | grep -v nodev` ]]
        then 
             	echo -e "${RED}Fail:	/tmp is not configured properly${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo -e "${GREEN}Pass:	/tmp is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.4 Ensure nosuid option set on /tmp partition"
if [[ -n `mount | grep -E '\s/tmp\s' | grep -v nosuid` ]]
        then
            	echo -e "${RED}Fail:	/tmp is not configured properly${ENDCOLOR}"
                failno=$(($failno + 1))
else 
     	echo -e "${GREEN}Pass:	/tmp is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

cho "1.1.5 Ensure noexec option set on /tmp partition "
if [[ -n `mount | grep -E '\s/tmp\s' | grep -v noexec` ]]
        then
            	echo -e "${RED}Fail:	/tmp is not configured properly${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo "${GREEN}Pass:	/tmp is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.8 Ensure nodev option set on /var/tmp partition"
if [[ -n `mount | grep -E '\s/var/tmp\s' | grep -v nodev` ]]
        then
            	echo -e "${RED}Fail:	/var/tmp is not configured properly${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo -e "${GREEN}Pass:	/var/tmp is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.9 Ensure nosuid option set on /var/tmp partition "
if [[ -n `mount | grep -E '\s/var/tmp\s' | grep -v nosuid` ]]
        then
            	echo -e "${RED}Fail:	/var/tmp is not configured properly${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo "${GREEN}Pass:	/var/tmp is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.10 Ensure noexec option set on /var/tmp partition "
if [[ -n `mount | grep -E '\s/var/tmp\s' | grep -v noexec` ]]
        then
            	echo -e "${RED}Fail:	/var/tmp is not configured properly${ENDCOLOR}"
                failno=$(($failno + 1))
else
        echo -e "${GREEN}Pass:	/var/tmp is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.14 Ensure nodev option set on /home partition"
if [[ -n `mount | grep -E '\s/home\s' | grep -v nodev` ]]
        then
            	echo -e "${RED}Fail:	/home is not configured properly${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo -e "${GREEN}Pass:	/home is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.15 Ensure nodev option set on /dev/shm partition"
if [[ -n `mount | grep -E '\s/dev/shm\s' | grep -v nodev` ]]
        then
            	echo -e "${RED}Fail:	/dev/shm is not configured properly${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo -e "${GREEN}Pass:	1.1.15 is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.16 Ensure nosuid option set on /dev/shm partition"
if [[ -n `mount | grep -E '\s/dev/shm\s' | grep -v nosuid` ]]
        then
            	echo -e "${RED}Fail:	/dev/shm is not configured properly${ENDCOLOR}"
                failno=$(($failno + 1))
else
        echo -e "${GREEN}Pass:	/dev/shm is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.17 Ensure noexec option set on /dev/shm partition"
if [[ -n `mount | grep -E '\s/dev/shm\s' | grep -v noexec` ]]
        then
            	echo -e "${RED}Fail:	/dev/shm is not configured properly${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo -e "${GREEN}Pass:	1.1.17 is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.21 Ensure sticky bit is set on all world-writable directories"
if [[ -n `df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}'
 -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null` ]]
        then
            	echo -e "${RED}Fail:	Sticky bit is not set on all world-writable diectories${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo -e "${GREEN}Pass:	Sticky bit is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.2.1 Ensure GPG keys are configured"
echo -e "${RED}CHECK:	Verify GPG keys are configured correctly for your packet manager${ENDCOLOR}"
rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n'

echo "1.2.2 Ensure gpgcheck is globally activated"
if [[ `grep ^gpgcheck /etc/yum.conf` != 'gpgcheck=1' ]]
        then
            	echo -e "${RED}Fail:	gpgcheck is not globally activated ${ENDCOLOR}"
                failno=$(($failno + 1))
else
        echo -e "${GREEN}Pass:	gpgcheck is configured correctly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.2.3 Ensure package manager repositories are configured"
echo -e "${RED}CHECK:	Verify that repositories are configured correctly${ENDCOLOR}"
dnf repolist

echo "1.3.1 Ensure sudo is installed"
if [[ -z `rpm -q sudo` ]]
        then
            	echo -e "${RED}Fail:	sudo is not installed${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo -e "${GREEN}Pass:	sudo is installed${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.3.2 Ensure sudo commands use pty"
if [[ `grep -Ei '^\s*Deafults\s+(\[^#]+,\s*)?use pty' /etc/sudoers /etc/sudoers.d/*` != 'Defaults use_pty' ]] 2> /dev/null
        then
            	echo -e "${RED}Fail:	sudo commands are not configured properly${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo -e "${GREEN}Pass:	sudo commands are configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.3.3 Ensure sudo log file exists"
if [[ -f `grep -Ei '^\s*Defaults\s+([^#]+,\s*)?logfile=' /etc/sudoers /etc/sudoers.d/*` ]] 2> /dev/null
        then
            	echo -e "${GREEN}Pass:	sudo log file exists${ENDCOLOR}"
                passno=$(($passno + 1))
else
    	echo -e "${RED}Fail:	sudo log file does not exist${ENDCOLOR}"
        failno=$(($failno + 1))
fi
echo "END OF CHAPTER 1"
echo
echo CHAPTER 2 : SERVICES
echo
echo 2.1 inetd Services
echo
#LEVEL 1 SERVER & LEVEL 1 WORKSTATION
echo 2.1.1 Ensure xinetd is not installed
xinetdcheck=$(rpm -q xinetd)
if [[ $xinetdcheck != 'package xinetd is not installed' ]]
then
	echo -e ''${RED}'Fail:	'$xinetdcheck' is installed.'${ENDCOLOR}''
failno=$(($failno + 1))
else
	echo -e "${GREEN}Pass:	xinetd is not installed${ENDCOLOR}"
passno=$(($passno + 1))

fi

echo
echo 2.2 Time Synchronisation
echo

echo 2.2.1.1 Ensure time synchronisation is in use
chronycheck=$(rpm -q chrony)
if [[ $chronycheck = 'package chrony is not installed' ]]
then
	echo -e "${RED}Fail:	chrony is not installed${ENDCOLOR}"
failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	chrony is installed${ENDCOLOR}"
passno=$(($passno + 1))

fi



#LEVEL 1 SERVER & LEVEL 1 WORKSTATION (cups is level 1 server and level 2 workstation)
n=3
services=(rsyncd avahi-daemon snmpd squid smb dovecot httpd vsftpd named nfs rpcbind slapd dhcpd ypserv)
for s in "${services[@]}"
do
	servicetest=$(systemctl is-enabled $s 2>/dev/null)
	if [[ "$servicetest"  = 'enabled' ]]
	then
		echo ''2.2.$n' Ensure '$s' server is not enabled'
		echo -e "${RED}Fail:	$s is enabled${ENDCOLOR}"
		#echo Run the following command to disable $s: systemctl --now disable $s
		n=$(($n + 1))
	failno=$(($failno + 1))
	else
		echo ''2.2.$n' Ensure '$s' server is not enabled'
		echo -e "${GREEN}Pass:	$s is not enabled${ENDCOLOR}"
		echo "$n" > /dev/null
		n=$(($n + 1))
passno=$(($passno + 1))

	fi
done

echo 2.2.18 Ensure mail transfer agent is configured for local-only mode
localonlymtatest=$(ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s')
if [[ -n $localonlymtatest ]]
then
	echo -e "${RED}Fail:	Mail transfer agent is not configured for local-only mode${ENDCOLOR}"
failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	MTA is not listening on any non-loopback address(127.0.0.1 or ::1)${ENDCOLOR}"
passno=$(($passno + 1))

fi

echo
echo 2.3 Service Clients
echo


n=1
serviceclients=(ypbind telnet openldap-clients)
for s in "${serviceclients[@]}"
do
	if [[ -z `rpm -q $s | grep 'is not installed'` ]]
	then
		if [[ $n = 1 ]]
		then
			echo 2.3.1 Ensure NIS Client is not installed
			echo "${RED}Fail:	$s is installed${ENDCOLOR}"
		elif [[ $n = 2 ]]
		then
			echo 2.3.2 Ensure telnet client is not installed
			echo -e "${RED}Fail:	$s is installed${ENDCOLOR}"
		elif [[ $n = 3 ]]
		then
			echo 2.3.3 Ensure LDAP client is not installed
			echo -e "${RED}Fail:	'$s' is installed${ENDCOLOR}"
		fi
		n=$(($n + 1))
        failno=$(($failno + 1))
	else
		if [[ $n = 1 ]]
		then
			echo 2.3.1 Ensure NIS Client is not installed
			echo -e "${GREEN}Pass:	'$s' is not installed${ENDCOLOR}"
		elif [[ $n = 2 ]]
		then
			echo 2.3.2 Ensure telnet client is not installed
			echo -e "${GREEN}Pass:	'$s' is not installed${ENDCOLOR}"
		elif [[ $n = 3 ]]
		then
			echo 2.3.3 Ensure LDAP client is not installed
			echo -e "${GREEN}Pass:	'$s' is not installed${ENDCOLOR}"
		fi
               
		echo "$n" > /dev/null
                n=$(($n + 1))
passno=$(($passno + 1))
	fi
done
#Chapter 3
echo CHAPTER 3: NETWORK CONFIGURATION
echo
echo 3.1 Network Parameters Host Only
echo 3.1.1 Ensure IP forwarding is disabled
#3.1.1
ipv4forwardcheck=$(sysctl net.ipv4.ip_forward)
ipv6allforwardcheck=$(sysctl net.ipv6.conf.all.forwarding)
        if [[ $ipv4forwardcheck == 'net.ipv4.ip_forward = 0' ]] && [[ $ipv6allforwardcheck == 'net.ipv6.conf.all.forwarding = 0' ]]
        then
                echo -e "${GREEN}Pass:	IP forwarding is disabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	IP forwarding is not disabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.1.2 Ensure packet redirect sending is disabled
#3.1.2
ipv4allredirectcheck=$(sysctl net.ipv4.conf.all.send_redirects)
ipv4defaultredirectcheck=$(sysctl net.ipv4.conf.default.send_redirects)
        if [[ $ipv4allredirectcheck == 'net.ipv4.conf.all.send_redirects = 0' ]] && [[ $ipv4defaultredirectcheck == 'net.ipv4.conf.default.send_redirects = 0' ]]
        then
                echo -e "${GREEN}Pass:	Packet redirect sending is disabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	Packet redirect sending is not disabled
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
                echo -e "${GREEN}Pass:	Source routed packets are not accepted
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	Source routed packets are accepted
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
                echo -e "${GREEN}Pass:	ICMP redirects are not accepted
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	ICMP redirects are accepted
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.3 Ensure secure ICMP redirects are not accepted
#3.2.3
secureaicmpcheck=$(sysctl net.ipv4.conf.all.secure_redirects)
securedicmpcheck=$(sysctl net.ipv4.conf.default.secure_redirects)
        if [[ $secureaicmpcheck == 'net.ipv4.conf.all.accept_redirects = 0' ]] && [[ $securedicmpcheck == 'net.ipv4.conf.default.accept_redirects = 0' ]]
        then
                echo -e "${GREEN}Pass:	Secure ICMP redirects are not accepted
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	Secure ICMP redirects are accepted
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.4 Ensure suspicious packets are logged
#3.2.4
packetlogacheck=$(sysctl net.ipv4.conf.all.log_martians)
packetlogdcheck=$(sysctl net.ipv4.conf.default.log_martians)
        if [[ $packetlogacheck == 'net.ipv4.conf.all.log_martians = 1' ]] && [[ $packetlogdcheck == 'net.ipv4.conf.default.log_martians = 1' ]]
        then
                echo -e "${GREEN}Pass:	Suspicious packets are logged
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	Suspicious packets are not logged
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.5 Ensure broadcast ICMP requests are ignored
#3.2.5
broadcasticmpcheck=$(sysctl net.ipv4.icmp_echo_ignore_broadcasts)
        if [[ $broadcasticmpcheck == 'net.ipv4.icmp_echo_ignore_broadcasts = 1' ]]
        then
                echo -e "${GREEN}Pass:	Broadcast ICMP requests are ignored
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	Broadcast ICMP requests are not ignored
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.6 Ensure bogus ICMP responses are ignored
#3.2.6
icmpboguscheck=$(sysctl net.ipv4.icmp_ignore_bogus_error_responses)
        if [[ $icmpboguscheck == 'net.ipv4.icmp_ignore_bogus_error_responses = 1' ]]
        then
                echo -e "${GREEN}Pass:	Bogus ICMP responses are ignored
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	Bogus ICMP responses are not ignored
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.7 Ensure Reverse Path Filtering is enabled
#3.2.7
reversepathafilter=$(sysctl net.ipv4.conf.all.rp_filter)
reversepathdfilter=$(sysctl net.ipv4.conf.default.rp_filter)
        if [[ $reversepathafilter == 'net.ipv4.conf.all.rp_filter = 1' ]] && [[ $reversepathdfilter == 'net.ipv4.conf.default.rp_filter = 1' ]]
        then
                echo -e "${GREEN}Pass:	Reverse Path Filtering is enabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	Reverse Path Filtering is not enabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.8 Ensure TCP SYN Cookies is enabled
#3.2.8
syncookies=$(sysctl net.ipv4.tcp_syncookies)
        if [[ $syncookies == 'net.ipv4.tcp_syncookies = 1' ]]
        then
                echo -e "${GREEN}Pass:	TCP SYN Cookies is enabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	TCP SYN Cookies is not enabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.2.9 Ensure IPv6 router advertisements are not accepted
#3.2.9
routeradda=$(sysctl net.ipv6.conf.all.accept_ra)
routeraddd=$(sysctl net.ipv6.conf.default.accept_ra)
        if [[ $routeradda == 'net.ipv6.conf.all.accept_ra = 0' ]] && [[ $routeraddd == 'net.ipv6.conf.default.accept_ra = 0' ]]
        then
                echo -e "${GREEN}Pass:	IPv6 router advertisements are not accepted
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	IPv6 router advertisements are accepted
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
                echo -e "${RED}Fail:	No firewall package is installed
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        elif [[ $nftables == 'package nftables is not installed' ]]
        then
                echo -e "${RED}Fail:	No firewall pacakge is installed
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        elif [[ $iptables == 'package iptables is no installed' ]]
        then
                echo -e "${RED}Fail:	No firewall package is installed
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:	A firewall package is installed
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        fi


echo 3.4.2 Configure firewalld
echo 3.4.2.1 Ensure firewalld service is enabled and running
#3.4.2.1
firewallrunning=$(firewall-cmd --state)
        if [[ `systemctl is-enabled firewalld 2>/dev/null`  == 'enabled' ]] && [[ $firewallrunning == 'running' ]]
        then
                echo -e "${GREEN}Pass:	firewalld service is enabled and running
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	firewalld service is not enabled and not running
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.4.2.2 Ensure nftables is not enabled
#3.4.2.2
        if [[ `systemctl is-enabled nftables 2>/dev/null`  == 'disabled' || 'masked' ]]
        then
                echo -e "${GREEN}Pass:	nftables is not enabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	nftables is enabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.4.2.3 Ensure default zone is set
#3.4.2.3
defaultzone=$(firewall-cmd --get-default-zone)
        if [[ $defaultzone == 'public' ]]
        then
                echo -e "${GREEN}Pass:	Default zone is set
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	Default zone is not set
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
                echo -e "${GREEN}Pass:	iptables is not enabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	iptables is enabled
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.4.3 Configure nftables
echo 3.4.3.1 Ensure iptables are flushed
#3.4.3.1
        if [[ -n `iptables -L` ]] && [[ -n `ip6tables -L` ]]
        then
                echo -e "${GREEN}Pass:	iptables are flushed
                ${ENDCOLOR}"
                passno=$(($passno + 1))

        else
                echo -e "${RED}Fail:	iptables are not flushed
                ${ENDCOLOR}"
                failno=$(($failno + 1))

        fi


echo 3.4.3.2 Ensure a table exists
#3.4.3.2
tableexist=$(nft list tables)
        if [[ -n $tableexist ]]
        then
                echo -e "${GREEN}Pass:	A table exists
                ${ENDCOLOR}"
                passno=$(($passno + 1))

        else
                echo -e "${RED}Fail:	No table exists
                ${ENDCOLOR}"
                failno=$(($failno + 1))

        fi


echo 3.4.3.3 Ensure base chains exist
#3.4.3.3
#Unsure about this one, pretty sure its wrong.
if [[ `nft list ruleset | grep 'hook input' 2>/dev/null` == 'type filter hook input priority 0;' ]] && [[ `nft list ruleset | grep 'hook forward' 2>/dev/null` == 'type filter hook forward priority 0;' ]] && [[ `nft list ruleset | grep 'hook output' 2>/dev/null` == 'type filter hook output priority 0;' ]]

        then
                echo -e "${GREEN}Pass:	base chains exists
                ${ENDCOLOR}"
                passno=$(($passno + 1))

        else
                echo -e "${RED}Fail:	base chains do not exists
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
                echo -e "${RED}Fail:	loopback traffic is not configured
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:	loopback traffic is configured
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        fi


echo 3.4.3.5 Ensure outbound and established connections are configured
#3.4.3.5
outboundconf=$(nft list ruleset | awk '/hook input/,/}/' | grep -E 'ip protocol (tcp|udp|icmp) ct state')
        if [[ `$outboundconf 2>/dev/null`  == 'ip protocol tcp ct state established accept' ]] && [[ `$outboundconf 2>/dev/null` == 'ip protocol udp ct state established accept' ]] && [[ `$outboundconf 2>/dev/null` == 'ip protocol icmp ct state established accept' ]]
        then
                echo -e "${GREEN}Pass:	outbound and established connections are configured
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	outbound and established connections are not configured
                ${ENDCOLOR}"
                failno=$(($failno + 1))
        fi


echo 3.4.3.6 Ensure default deny firewall policy
#3.4.3.6
if [[ `nft list ruleset | grep 'hook input' 2>/dev/null` == 'type filter hook input priority 0; policy drop;' ]] && [[ `nft list ruleset | grep 'hook forward' 2>/dev/null` == 'type filter hook forward priority 0; policy drop;' ]] && [[ `nft list ruleset | grep 'hook output' 2>/dev/null` == 'type filter hook output priority 0; policy drop;' ]]
        then
                echo -e "${GREEN}Pass:	default firewall policy is deny
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	default firewall policy is not deny
                ${ENDCOLOR}"
                failno=$(($failno + 1))

        fi


echo 3.4.3.7 Ensure nftables service is eabled
#3.4.3.7
        if [[ `systemctl is-enabled nftables 2>/dev/null` == 'enabled' ]]
        then
                echo -e "${GREEN}Pass:	nftables service is enabled
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	nftables service is not enabled
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
                echo -e "${GREEN}Pass:	default firewall policy is deny
                ${ENDCOLOR}"
                passno=$(($passno + 1))
        else
                echo -e "${RED}Fail:	default firewall policy is not deny
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
echo
#----------------------------
#CHAP 4
echo
echo PART 4 : LOGGING AND AUDITING
echo
echo 4.2 Configure logging
echo
echo 4.2.1 COnfigure rsyslog
echo

echo 4.2.1.1 Ensure rsyslog is installed
if [[ `rpm -q rsyslog` =~ 'rsyslog' ]]
then
	echo -e "${GREEN}Pass:	rsyslog is installed${ENDCOLOR}"
passno=$(($passno + 1))

else
	echo -e "${RED}Fail:	rsyslog is not installed${ENDCOLOR}" #Run the following command to install rsyslog: # dnf install rsyslog
failno=$(($failno + 1))
fi

echo 4.2.1.2 Ensure rsyslog Service is installed
if [[ `systemctl is-enabled rsyslog` != 'enabled' ]]
then
	echo -e "${RED}Fail:	rsyslog Service is not installed${ENDCOLOR}" #Run the following command to enable rsyslog: # systemctl --now enable rsyslog
failno=$(($failno + 1))
else
	echo -e "${GREEN}Pass:	rsyslog Service is installed${ENDCOLOR}"
passno=$(($passno + 1))

fi

echo 4.2.1.3 Ensure rsyslog default file permissions configured
check=$(grep ^\$FileCreateMode /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null | egrep "(0640||0600)")
if [[ -z $check ]]
then
	echo -e ''${RED}'Fail:	$FileCreateMode is not 0640 or more restrictive'${ENDCOLOR}'' #Edit the /etc/rsyslog.conf and /etc/rsyslog.d/*.conf files and set $FileCreateModeto 0640 or more restrictive:"$FileCreateMode 0640"'
failno=$(($failno + 1))
else
	echo -e ''${GREEN}'Pass:	$FileCreateMode is 0640 or more restrictive'${ENDCOLOR}''
passno=$(($passno + 1))

fi


echo 4.2.1.4 Ensure logging is configured
if [[ -z `ls -l /var/log/` ]]
then
	echo -e "${RED}Fail:	logging is not configured${ENDCOLOR}" #Edit the following lines in the /etc/rsyslog.confand /etc/rsyslog.d/*.conffiles
failno=$(($failno + 1))
else
	echo -e "${GREEN}Pass:	logging is configured (Check /etc/rsyslog.conf and /etc/rsyslog.d/*.conf and edit the lines as appropriate for your environment)${ENDCOLOR}"
passno=$(($passno + 1))

fi


echo 4.2.1.5 Ensure rsyslog is configured to send logs to a remote log host
if [[ -z `grep "^*.*[^I][^I]*@" /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null` ]]
then
	echo -e "${RED}Fail:	rysyslog is not configured to send logs to a remote log host${ENDCOLOR}" #Edit the /etc/rsyslog.conf and /etc/rsyslog.d/*.conf files and add the following line (where loghost.example.com is the name of your central log host). *.* @@loghost.example.com  then run the following command to reload the rsyslogd configuration: # systemctl restart rsyslog'
failno=$(($failno + 1))
else
	echo -e "${GREEN}Pass:	rsyslog sends logs to remote log host${ENDCOLOR}"
passno=$(($passno + 1))

fi

echo
echo 4.2.2 Configure Journald
echo

echo 4.2.2.1 Ensure journald is configured to send logs to rsyslog
if [[ `grep -e ^\s*ForwardToSyslog /etc/systemd/journald.conf` != 'ForwardToSyslog=yes' ]]
then
	echo -e "${RED}Fail:	journald does not forward logs to syslog${ENDCOLOR}" #Edit the /etc/systemd/journald.conf file and add the following line: ForwardToSyslog=yes
failno=$(($failno + 1))
else
	echo -e "${GREEN}Pass:	journald forwards logs to syslog${ENDCOLOR}"
passno=$(($passno + 1))

fi

echo 4.2.2.2 Ensure journald is configured to compress large log files
if [[ `grep -e ^\s*Compress /etc/systemd/journald.conf` != 'Compress=yes' ]]
then
	echo -e "${RED}Fail:	journald is not configured to compress larger files${ENDCOLOR}" #Edit the /etc/systemd/journald.conf file and add the following line: Compress=yes
failno=$(($failno + 1))
else
	echo -e "${GREEN}Pass:	journald is set to compress large files${ENDCOLOR}"
passno=$(($passno + 1))

fi

echo 4.2.2.3 Ensure journald is configured to write logfiles to persistent disk
if [[ `grep -e ^\s*Storage /etc/systemd/journald.conf` != 'Storage=persistent' ]]
then
	echo -e "${RED}Fail:	logs are not persisted to disk${ENDCOLOR}" #Edit the /etc/systemd/journald.conf file and add the following line: Storage=persistent
failno=$(($failno + 1))
else
	echo -e "${GREEN}Pass:	logs are persisted to disk${ENDCOLOR}"
passno=$(($passno + 1))

fi

echo 4.2.3 Ensure permissions on all logfiles are configured
if [[ -n `find /var/log -type f -perm /037 -ls -o -type d -perm /026 -ls` ]]
then
	echo -e "${RED}Fail:	Other has permissions on some files and Group has write or execute permissions on some files${ENDCOLOR}" #Run the following commands to set permissions on all existing log files: find /var/log -type f -exec chmod g-wx,o-rwx "{}" + -o -type d -exec chmod g-w,o-rwx "{}" +
failno=$(($failno + 1))
else
	echo -e "${GREEN}Pass:	permissions are configured${ENDCOLOR}"
passno=$(($passno + 1))

fi

echo
#-----------------------------------------
#CHAP 6 workstation lvl 1
echo
echo 6.1.2  Ensure permissions on /etc/passwd are configured

pcheck=$(stat --format="%A" /etc/passwd)
if [[ $pcheck != "-rw-r--r--" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 421)${ENDCOLOR}"
	passno=$(($passno + 1))
fi

echo 6.1.3  Ensure permissions on /etc/shadow are configured

pecheck=$(stat --format="%A" /etc/shadow)
if [[ $pecheck != "-rw-r-----" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 422)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.4  Ensure permissions on /etc/group are configured

percheck=$(stat --format="%A" /etc/group)
if [[ $percheck != "-rw-r--r--" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 423)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.5  Ensure permissions on /etc/gshadow are configured

permcheck=$(stat --format="%A" /etc/gshadow)
if [[ $permcheck != "-rw-r-----" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 424)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.6  Ensure permissions on /etc/passwd- are configured

permicheck=$(stat --format="%A" /etc/passwd-)
if [[ $permicheck != "-rw-------" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 425)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.7  Ensure permissions on /etc/shadow- are configured

permischeck=$(stat --format="%A" /etc/shadow-)
if [[ $permischeck != "-rw-------" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 426)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.8  Ensure permissions on /etc/group- are configured

permisscheck=$(stat --format="%A" /etc/group-)
if [[ $permisscheck != "-rw-------" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 428)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.9 Ensure permissions on /etc/gshadow- are configured

permissicheck=$(stat --format="%A" /etc/gshadow-)
if [[ $permissicheck != "-rw-r-----" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 429)${ENDCOLOR}"
		passno=$(($passno + 1))

fi


echo 6.1.10 Ensure no world writable files exist

echeck=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002)
if [[ $echeck != "" ]]
then
	echo -e "${RED}Fail:	world writable files exist${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	No world writable files exist 	(PAGE 430)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.11 Ensure no unowned files or directories exist

encheck=$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser)
if [[ $encheck != "" ]]
then
	echo -e "${RED}Fail:	unowned files or directories exist${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	No unowned files or directories exist 	(PAGE 432)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.12 Ensure no ungrouped files or directories exist

enscheck=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nogroup)
if [[ $enscheck != "" ]]
then
	echo -e "${RED}Fail:	ungrouped files or directories exist${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	No ungrouped files or directories exist 	(PAGE 434)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.13 Audit SUID executables
echo Output listed:
df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -4000

echo 6.1.14 Audit SGID executables
echo Output listed:
df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -2000


echo 6.2.1 Ensure password fields are not empty

pcheck=$(awk -F: '($2 == "" ) { print $1 " does not have a password "}' /etc/shadow)
if [[ $pcheck != "" ]]
then
	echo -e "${RED}Fail:	password feilds are empty${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	password feilds are not empty 	(PAGE 441)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.2.2 Ensure no legacy "+" entries exist in /etc/passwd

lcheck=$(grep '^\+:' /etc/passwd)
if [[ $lcheck != "" ]]
then
	echo -e "${RED}Fail:	legacy "+" entries exist in /etc/passwd${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	no legacy "+" entries exist in /etc/passwd 	(PAGE 442)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.2.3 Ensure root PATH Integrity

poutput=$(for x in $(echo $PATH | tr ":" " ") ; do
 if [ -d "$x" ] ; then
 ls -ldH "$x" | awk '
$9 == "." {print "PATH contains current working directory (.)"}
$3 != "root" {print $9, "is not owned by root"}
substr($1,6,1) != "-" {print $9, "is group writable"}
substr($1,9,1) != "-" {print $9, "is world writable"}'
 else
 echo "$x is not a directory"
 fi
done)
if [[ -z "$poutput" ]]
then
 echo -e "${GREEN}Pass:	Ensure root PATH Integrity${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	Cant ensure root PATH Integrity 	(PAGE 443)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.4 Ensure no legacy "+" entries exist in /etc/shadow

lecheck=$(grep '^\+:' /etc/shadow)
if [[ $lecheck != "" ]]
then
	echo -e "${RED}Fail:	legacy "+" entries exist in /etc/shadow${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	no legacy "+" entries exist in /etc/shadow 	(PAGE 444)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.2.5 Ensure no legacy "+" entries exist in /etc/group

legcheck=$(grep '^\+:' /etc/group)
if [[ $legcheck != "" ]]
then
	echo -e "${RED}Fail:	legacy "+" entries exist in /etc/group${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	no legacy "+" entries exist in /etc/group 	(PAGE 445)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.2.6 Ensure root is the only UID 0 account

rcheck=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)
if [[ $rcheck != "root" ]]
then
	echo -e "${RED}Fail:	root is the only UID 0 account${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	root is the only UID 0 account 	(PAGE 446)${ENDCOLOR}" 
		passno=$(($passno + 1))

fi

echo 6.2.7 Ensure users home directories permissions are 750 or more restrictive

hooutput=$(grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which /sbin/nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
 if [ ! -d "$dir" ]; then
 echo "The home directory ($dir) of user $user does not exist."
 else
 dirperm=$(ls -ld $dir | cut -f1 -d" ")
 if [ $(echo $dirperm | cut -c6) != "-" ]; then
 echo "Group Write permission set on the home directory ($dir) of user
$user"
 fi
 if [ $(echo $dirperm | cut -c8) != "-" ]; then
 echo "Other Read permission set on the home directory ($dir) of user
$user"
 fi
 if [ $(echo $dirperm | cut -c9) != "-" ]; then
 echo "Other Write permission set on the home directory ($dir) of user
$user"
 fi
 if [ $(echo $dirperm | cut -c10) != "-" ]; then
 echo "Other Execute permission set on the home directory ($dir) of user
$user"
 fi
 fi
done)

if [[ -z "$hooutput" ]]
then
 echo -e "${GREEN}Pass:	users home directories permissions are 750 or more restrictive${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	users home directories permissions are NOT 750 or more restrictive 	(PAGE 447)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.8 Ensure users own their home directories

houtput=$(grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which /sbin/nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read -r user dir; do
    if [ ! -d "$dir" ]; then
        echo "The home directory ($dir) of user $user does not exist."
    else
        owner=$(stat -L -c "%U" "$dir")
        if [ "$owner" != "$user" ]; then
            echo "The home directory ($dir) of user $user is owned by $owner."
        fi
		
    fi
done)

if [[ -z "$houtput" ]]
then
 echo -e "${GREEN}Pass:	users own their home directories${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	users do not own their home directories 	(PAGE 449)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.9 Ensure users dot files are not group or world writable
 
woutput=$(grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which /sbin/nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
 if [ ! -d "$dir" ]; then
	echo "The home directory ($dir) of user $user does not exist."
 else
for file in $dir/.[A-Za-z0-9]*; do
	if [ ! -h "$file" -a -f "$file" ]; then
		fileperm=$(ls -ld $file | cut -f1 -d" ")
	if [ $(echo $fileperm | cut -c6) != "-" ]; then
		echo "Group Write permission set on file $file"
	fi
		if [ $(echo $fileperm | cut -c9) != "-" ]; then
		echo "Other Write permission set on file $file"
	fi
 fi
 done
 fi
done)
if [[ -z "$woutput" ]]
then
 echo -e "${GREEN}Pass:	users dot files are not group or world writable${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	users dot files are group or world writable 	(PAGE 451)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.10 Ensure no users have .forward files

fcheck=$(grep -E -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which /sbin/nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
 if [ ! -d "$dir" ]; then
 echo "The home directory ($dir) of user $user does not exist."
 else
 if [ ! -h "$dir/.forward" -a -f "$dir/.forward" ]; then
 echo ".forward file $dir/.forward exists"
 fi
 fi
done)
if [[ -z "$fcheck" ]]
then
 echo -e "${GREEN}Pass:	no users have .forward files${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	users have .forward files 	(PAGE 453)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.11 Ensure no users have .netrc files

ncheck=$(grep -E -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which /sbin/nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
 if [ ! -d "$dir" ]; then
 echo "The home directory ($dir) of user $user does not exist."
 else
 if [ ! -h "$dir/.netrc" -a -f "$dir/.netrc" ]; then
 echo ".netrc file $dir/.netrc exists"
 fi
 fi
done)
if [[ -z "$ncheck" ]]
then
 echo -e "${GREEN}Pass:	No users have .netrc files${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	Users have .netrc files 	(PAGE 455)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.12 Ensure users .netrc Files are not group or world accessible

ucheck=$(grep -E -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which /sbin/nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
 if [ ! -d "$dir" ]; then
	echo "The home directory ($dir) of user $user does not exist."
 else
	for file in $dir/.netrc; do
if [ ! -h "$file" -a -f "$file" ]; then
	fileperm=$(ls -ld $file | cut -f1 -d" ")
 if [ $(echo $fileperm | cut -c5) != "-" ]; then
	echo "Group Read set on $file"
		fi
 if [ $(echo $fileperm | cut -c6) != "-" ]; then
	echo "Group Write set on $file"
		fi
 if [ $(echo $fileperm | cut -c7) != "-" ]; then
	echo "Group Execute set on $file"
		fi
 if [ $(echo $fileperm | cut -c8) != "-" ]; then
	echo "Other Read set on $file"
		fi
 if [ $(echo $fileperm | cut -c9) != "-" ]; then
	echo "Other Write set on $file"
		fi
 if [ $(echo $fileperm | cut -c10) != "-" ]; then
	echo "Other Execute set on $file"
 fi
 fi
 done
 fi
done)
if [[ -z "$ucheck" ]]
then
 echo -e "${GREEN}Pass:	users .netrc Files are not group or world accessible${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	users .netrc Files are group or world accessible 	(PAGE 457)${ENDCOLOR}"
failno=$(($failno + 1))
fi


echo 6.2.13 Ensure no users have .rhosts files

rhcheck=$(grep -E -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which /sbin/nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
 if [ ! -d "$dir" ]; then
 echo "The home directory ($dir) of user $user does not exist."
 else
 for file in $dir/.rhosts; do
 if [ ! -h "$file" -a -f "$file" ]; then
 echo ".rhosts file in $dir"
 fi
 done
 fi
done)
if [[ -z "$rhcheck" ]]
then
 echo -e "${GREEN}Pass:	no users have .rhosts files${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	users have .rhosts files 	(PAGE 460)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.14 Ensure all groups in /etc/passwd exist in /etc/group

echeck=$(for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do
 grep -q -P "^.*?:[^:]*:$i:" /etc/group
 if [ $? -ne 0 ]; then
 echo "Group $i is referenced by /etc/passwd but does not exist in
/etc/group"
 fi
done)
if [[ -z "$ehcheck" ]]
then
 echo -e "${GREEN}Pass:	all groups in /etc/passwd exist in /etc/group${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	all groups in /etc/passwd do not exist in /etc/group 	(PAGE 462)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.15 Ensure no duplicate UIDs exist

grcheck=$(cut -f3 -d":" /etc/passwd | sort -n | uniq -c | while read x ; do
 [ -z "$x" ] && break
 set - $x
 if [ $1 -gt 1 ]; then
 users=$(awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | xargs)
 echo "Duplicate UID ($2): $users"
 fi
done)
if [[ -z "$grcheck" ]]
then
 echo -e "${GREEN}Pass:	no duplicate UIDs exist${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	Duplicate UIDs exist 	(PAGE 463)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.16 Ensure no duplicate GIDs exist

gicheck=$(cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do
 echo "Duplicate GID ($x) in /etc/group"
done
)
if [[ -z "$gicheck" ]]
then
 echo -e "${GREEN}Pass:	no duplicate GIDs exist${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	duplicate GIDs exist 	(PAGE 464)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.17 Ensure no duplicate user names exist

excheck=$(cut -d: -f1 /etc/passwd | sort | uniq -d | while read x
do echo "Duplicate login name ${x} in /etc/passwd"
done)
if [[ -z "$excheck" ]]
then
 echo -e "${GREEN}Pass:	no duplicate user names exist${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	duplicate user names exist 	(PAGE 465)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.18 Ensure no duplicate group names exist

exicheck=$(cut -d: -f1 /etc/group | sort | uniq -d | while read x
do echo "Duplicate group name ${x} in /etc/group"
done)
if [[ -z "$exicheck" ]]
then
 echo -e "${GREEN}Pass:	no duplicate group names exist${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	duplicate group names exist 	(PAGE 466)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.19 Ensure shadow group is empty

emptycheck=$(grep ^shadow:[^:]*:[^:]*:[^:]+ /etc/group | awk -F: '($4 == "<shadow-gid>") { print }' /etc/passwd)
if [[ -z "$emptycheck" ]]
then
 echo -e "${GREEN}Pass:	shadow group is empty${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	shadow group is NOT empty 	(PAGE 467)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.20 Ensure all users home directories exist 

emptycheck=$(grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which /sbin/nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read -r user dir; do
if [ ! -d "$dir" ]; then
echo "The home directory ($dir) of user $user does not exist."
fi
done)
if [[ -z "$emptycheck" ]]
then
 echo -e "${GREEN}Pass:	all users home directories exist${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	Not all users home directories exist 	(PAGE 468)${ENDCOLOR}"
failno=$(($failno + 1))
fi




echo 'NUMBER OF PASSES:	'$passno''
echo 'NUMBER OF FAILED:	'$failno''


