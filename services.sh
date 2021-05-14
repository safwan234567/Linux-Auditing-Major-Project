#! /bin/bash

script (){
echo --------------------
date
echo --------------------
passno=0
failno=0
echo 2.1 inetd Services

xinetdcheck=$(rpm -q xinetd)
if [[ $xinetdcheck != 'package xinetd is not installed' ]]
then
	echo Fail: 2.1.1 #$xinetdcheck is installed. 
failno=$(($failno + 1))
else
	echo PASS
passno=$(($passno + 1))

fi

echo
echo 2.2 Time Synchronisation

chronycheck=$(rpm -q chrony)
if [[ $chronycheck = 'package chrony is not installed' ]]
then
	echo Fail: 2.2.1.1 #chrony is not installed
failno=$(($failno + 1))
else 
	echo PASS
passno=$(($passno + 1))

fi

x11check=$(rpm -qa xorg-x11*)
if [[ -n $x11check ]]
then
	echo Fail: 2.2.2 #X Window System is installed (GUI)
failno=$(($failno + 1))
else
	echo PASS
passno=$(($passno + 1))

fi

n=3
services=(rsyncd avahi-daemon snmpd squid smb dovecot httpd vsftpd named nfs rpcbind slapd dhcpd cups ypserv)
for s in "${services[@]}"
do
	servicetest=$(systemctl is-enabled $s 2>/dev/null)
	if [[ "$servicetest"  = 'enabled' ]]
	then
		echo Fail: 2.2.$n #$s is enabled
		#echo Run the following command to disable $s: systemctl --now disable $s
		n=$(($n + 1))
	failno=$(($failno + 1))
	else
		echo PASS
		echo "$n" > /dev/null
		n=$(($n + 1))
passno=$(($passno + 1))

	fi
done

localonlymtatest=$(ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s')
if [[ -n $localonlymtatest ]]
then
	echo Fail: 2.2.18 #Mail transfer agent is not configured for local-only mode
failno=$(($failno + 1))
else 
	echo PASS
passno=$(($passno + 1))

fi

echo
echo 2.3 Service Clients
n=1
serviceclients=(ypbind telnet openldap-clients)
for s in "${serviceclients[@]}"
do
	if [[ -z `rpm -q $s | grep 'is not installed'` ]]
	then
		echo Fail: 2.3.$n #$s is installed
		n=$(($n + 1))
        failno=$(($failno + 1))
	else
                echo PASS
		echo "$n" > /dev/null
                n=$(($n + 1))
passno=$(($passno + 1))

	fi
done

echo 'NUMBER OF PASSES:	'$passno''
echo 'NUMBER OF FAILED:	'$failno''
}
script | tr '\t' ',' >> all_audits.csv
script | tr '\t' ' ' > latestresult.csv
echo 
cat latestresult.csv
echo To view all previous audits in csv format, 'cat all_audits.csv'
