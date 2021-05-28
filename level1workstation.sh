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
	echo -e "${GREEN}Pass:	Permisions are set${ENDCOLOR}"
	passno=$(($passno + 1))
fi

echo 6.1.3  Ensure permissions on /etc/shadow are configured

pecheck=$(stat --format="%A" /etc/shadow)
if [[ $pecheck != "-rw-r-----" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.4  Ensure permissions on /etc/group are configured

percheck=$(stat --format="%A" /etc/group)
if [[ $percheck != "-rw-r--r--" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.5  Ensure permissions on /etc/gshadow are configured

permcheck=$(stat --format="%A" /etc/gshadow)
if [[ $permcheck != "-rw-r-----" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.6  Ensure permissions on /etc/passwd- are configured

permicheck=$(stat --format="%A" /etc/passwd-)
if [[ $permicheck != "-rw-------" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.7  Ensure permissions on /etc/shadow- are configured

permischeck=$(stat --format="%A" /etc/shadow-)
if [[ $permischeck != "-rw-------" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.8  Ensure permissions on /etc/group- are configured

permisscheck=$(stat --format="%A" /etc/group-)
if [[ $permisscheck != "-rw-------" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.9 Ensure permissions on /etc/gshadow- are configured

permissicheck=$(stat --format="%A" /etc/gshadow-)
if [[ $permissicheck != "-rw-r-----" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set${ENDCOLOR}"
		passno=$(($passno + 1))

fi


echo 6.1.10 Ensure no world writable files exist

echeck=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002)
if [[ $echeck != "" ]]
then
	echo -e "${RED}Fail:	world writable files exist${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	No world writable files exist${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.11 Ensure no unowned files or directories exist

encheck=$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser)
if [[ $encheck != "" ]]
then
	echo -e "${RED}Fail:	unowned files or directories exist${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	No unowned files or directories exist${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.12 Ensure no ungrouped files or directories exist

enscheck=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nogroup)
if [[ $enscheck != "" ]]
then
	echo -e "${RED}Fail:	ungrouped files or directories exist${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	No ungrouped files or directories exist${ENDCOLOR}"
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
	echo -e "${GREEN}Pass:	password feilds are not empty${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.2.2 Ensure no legacy "+" entries exist in /etc/passwd

lcheck=$(grep '^\+:' /etc/passwd)
if [[ $lcheck != "" ]]
then
	echo -e "${RED}Fail:	legacy "+" entries exist in /etc/passwd${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	no legacy "+" entries exist in /etc/passwd${ENDCOLOR}"
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
echo -e "${RED}Fail:	Cant ensure root PATH Integrity${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.4 Ensure no legacy "+" entries exist in /etc/shadow

lecheck=$(grep '^\+:' /etc/shadow)
if [[ $lecheck != "" ]]
then
	echo -e "${RED}Fail:	legacy "+" entries exist in /etc/shadow${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	no legacy "+" entries exist in /etc/shadow${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.2.5 Ensure no legacy "+" entries exist in /etc/group

legcheck=$(grep '^\+:' /etc/group)
if [[ $legcheck != "" ]]
then
	echo -e "${RED}Fail:	legacy "+" entries exist in /etc/group${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	no legacy "+" entries exist in /etc/group${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.2.6 Ensure root is the only UID 0 account

rcheck=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)
if [[ $rcheck != "root" ]]
then
	echo -e "${RED}Fail:	root is the only UID 0 account${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	root is the only UID 0 account${ENDCOLOR}" 
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
echo -e "${RED}Fail:	users home directories permissions are NOT 750 or more restrictive${ENDCOLOR}"
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
echo -e "${RED}Fail:	users do not own their home directories${ENDCOLOR}"
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
echo -e "${RED}Fail:	users dot files are group or world writable${ENDCOLOR}"
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
echo -e "${RED}Fail:	users have .forward files${ENDCOLOR}"
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
echo -e "${RED}Fail:	Users have .netrc files${ENDCOLOR}"
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
echo -e "${RED}Fail:	users .netrc Files are group or world accessible${ENDCOLOR}"
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
echo -e "${RED}Fail:	users have .rhosts files${ENDCOLOR}"
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
echo -e "${RED}Fail:	all groups in /etc/passwd do not exist in /etc/group${ENDCOLOR}"
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
echo -e "${RED}Fail:	Duplicate UIDs exist${ENDCOLOR}"
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
echo -e "${RED}Fail:	duplicate GIDs exist${ENDCOLOR}"
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
echo -e "${RED}Fail:	duplicate user names exist${ENDCOLOR}"
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
echo -e "${RED}Fail:	duplicate group names exist${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.19 Ensure shadow group is empty

emptycheck=$(grep ^shadow:[^:]*:[^:]*:[^:]+ /etc/group | awk -F: '($4 == "<shadow-gid>") { print }' /etc/passwd)
if [[ -z "$emptycheck" ]]
then
 echo -e "${GREEN}Pass:	shadow group is empty${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	shadow group is NOT empty${ENDCOLOR}"
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
echo -e "${RED}Fail:	Not all users home directories exist${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 'NUMBER OF PASSES:	'$passno''
echo 'NUMBER OF FAILED:	'$failno''


