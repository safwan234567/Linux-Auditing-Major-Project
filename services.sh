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

services=(rsyncd avahi-daemon snmpd squid smb dovecot httpd vsftpd named nfs rpcbind slapd dhcpd cups ypserv)
for s in "${services[@]}"
do
	if [[ `systemctl is-enabled $s 2>/dev/null` = 'enabled' ]]
	then
		echo Fail: $s is enabled
	fi
done

localonlymtatest=$(ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s')
if [[ -n $localonlymtatest ]]
then
	echo Fail: Mail transfer agent is not configured for local-only mode
fi
echo
echo 2.3 Service Clients
serviceclients=(ypbind telnet openldap-clients)

for s in "${serviceclients[@]}"
do
	if [[ -z `rpm -q $s | grep 'is not installed'` ]]
	then
		echo Fail: $s is installed
	fi
done
