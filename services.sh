#! /bin/bash

#echo --------------------
#date
#echo --------------------
#echo
passno=0
failno=0
echo 2.1 inetd Services
echo

echo 2.1.1 Ensure xinetd is not installed
xinetdcheck=$(rpm -q xinetd)
if [[ $xinetdcheck != 'package xinetd is not installed' ]]
then
	echo 'Fail:	'$xinetdcheck' is installed.' 
failno=$(($failno + 1))
else
	echo 'Pass:	xinetd is not installed'
passno=$(($passno + 1))

fi

echo
echo 2.2 Time Synchronisation
echo

echo 2.2.1.1 Ensure time synchronisation is in use
chronycheck=$(rpm -q chrony)
if [[ $chronycheck = 'package chrony is not installed' ]]
then
	echo 'Fail:	chrony is not installed'
failno=$(($failno + 1))
else 
	echo 'Pass:	chrony is installed'
passno=$(($passno + 1))

fi

echo 2.2.2 Ensure X Window System is not installed
x11check=$(rpm -qa xorg-x11*)
if [[ -n $x11check ]]
then
	echo 'Fail:	X Window System is installed (GUI)'
failno=$(($failno + 1))
else
	echo 'Pass:	X Window System is not installed'
passno=$(($passno + 1))

fi

n=3
services=(rsyncd avahi-daemon snmpd squid smb dovecot httpd vsftpd named nfs rpcbind slapd dhcpd cups ypserv)
for s in "${services[@]}"
do
	servicetest=$(systemctl is-enabled $s 2>/dev/null)
	if [[ "$servicetest"  = 'enabled' ]]
	then
		echo ''2.2.$n' Ensure '$s' server is not enabled'
		echo 'Fail:	'$s' is enabled'
		#echo Run the following command to disable $s: systemctl --now disable $s
		n=$(($n + 1))
	failno=$(($failno + 1))
	else
		echo ''2.2.$n' Ensure '$s' server is not enabled'
		echo 'Pass:	'$s' is not enabled'
		echo "$n" > /dev/null
		n=$(($n + 1))
passno=$(($passno + 1))

	fi
done

echo 2.2.18 Ensure mail transfer agent is configured for local-only mode
localonlymtatest=$(ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s')
if [[ -n $localonlymtatest ]]
then
	echo 'Fail:	Mail transfer agent is not configured for local-only mode'
failno=$(($failno + 1))
else 
	echo 'Pass:	MTA is not listening on any non-loopback address(127.0.0.1 or ::1)'
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
			echo 'Fail:	'$s' is installed'
		elif [[ $n = 2 ]]
		then
			echo 2.3.2 Ensure telnet client is not installed
			echo 'Fail:	'$s' is installed'
		elif [[ $n = 3 ]]
		then
			echo 2.3.3 Ensure LDAP client is not installed
			echo 'Fail:	'$s' is installed'
		fi
		n=$(($n + 1))
        failno=$(($failno + 1))
	else
		if [[ $n = 1 ]]
		then
			echo 2.3.1 Ensure NIS Client is not installed
			echo 'Pass:	'$s' is not installed'
		elif [[ $n = 2 ]]
		then
			echo 2.3.2 Ensure telnet client is not installed
			echo 'Pass:	'$s' is not installed'
		elif [[ $n = 3 ]]
		then
			echo 2.3.3 Ensure LDAP client is not installed
			echo 'Pass:	'$s' is not installed'
		fi
               
		echo "$n" > /dev/null
                n=$(($n + 1))
passno=$(($passno + 1))
	fi
done

echo 'NUMBER OF PASSES:	'$passno''
echo 'NUMBER OF FAILED:	'$failno''


