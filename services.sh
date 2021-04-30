#! /bin/bash

echo 2.1 inetd Services

xinetdcheck=$(rpm -q xinetd)
if [[ $xinetdcheck != 'package xinetd is not installed' ]]
then
	echo Fail: $xinetdcheck is installed
fi

echo
echo 2.2 Time Synchronisation

chronycheck=$(rpm -q chrony)
if [[ $chronycheck = 'package chrony is not installed' ]]
then
	echo Fail: chrony is not installed
fi

x11check=$(rpm -qa xorg-x11*)
if [[ -n $x11check ]]
then
	echo "Fail: X Window System is installed (GUI)"
fi
n=3
services=(rsyncd avahi-daemon snmpd squid smb dovecot httpd vsftpd named nfs rpcbind slapd dhcpd cups ypserv)
for s in "${services[@]}"
do
	servicetest=$(systemctl is-enabled $s 2>/dev/null)
	if [[ "$servicetest"  = 'enabled' ]]
	then
		echo Fail: 2.2.$n $s is enabled
		echo Run the following command to disable $s: systemctl --now disable $s
		n=$(($n + 1))
	
	else
		echo "$n" > /dev/null
		n=$(($n + 1))
	fi
done

localonlymtatest=$(ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s')
if [[ -n $localonlymtatest ]]
then
	echo Fail: Mail transfer agent is not configured for local-only mode
fi
echo
echo 2.3 Service Clients
n=1
serviceclients=(ypbind telnet openldap-clients)
for s in "${serviceclients[@]}"
do
	if [[ -z `rpm -q $s | grep 'is not installed'` ]]
	then
		echo Fail: 2.3.$n $s is installed
		n=$(($n + 1))
        else
                echo "$n" > /dev/null
                n=$(($n + 1))

	fi
done


