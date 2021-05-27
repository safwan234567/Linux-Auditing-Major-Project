#! /bin/bash

passno=0
failno=0
RED="\e[91m"
GREEN="\e[92m"
ENDCOLOR="\e[0m"

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

echo 'NUMBER OF PASSES:	'$passno''
echo 'NUMBER OF FAILED:	'$failno''


