#! /bin/bash
passno=0
failno=0

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR='\e[0m'

echo
echo 4.1.1 Ensure auditing is enabled

echo 4.1.1.1 Ensure auditd is installed
if [[ -z `rpm -q audit audit-libs | grep audit-` ]]
then
	echo -e "${RED}Fail:	auditd is not installed${ENDCOLOR}"
failno=$(($failno + 1))

else
	echo -e "${GREEN}Pass:	auditd is installed${ENDCOLOR}"
passno=$(($passno + 1))

fi

echo 4.1.1.2 Ensure auditd service is enabled
if [[ `systemctl is-enabled auditd 2>/dev/null` != 'enabled' ]]
        then
        echo -e "${RED}Fail:	auditd service is not enabled${ENDCOLOR}"
failno=$(($failno + 1))
else
	echo -e "${GREEN}Pass:	auditd service is enabled${ENDCOLOR}"
passno=$(($passno + 1))

fi


n=3
perim=('kernelopts=(\S+\s+)*audit=1\b' 'kernelopts=(\S+\s+)*audit_backlog_limit=\S+\b')
for p in "${perim[@]}"
do

        if [[ -z `grep -E "$p" /boot/grub2/grubenv` ]]
        then
                           
		if [[ $n = 3 ]]
		then
			echo '4.1.1.3 Ensure auditing for processees that start prior to auditd is enabled'
			echo -e "${RED}Fail:	auditing for processes that start prior to auditd is dis:abled${ENDCOLOR}"
#echo Fail: 4.1.1.$n #Edit /etc/default/grub and add audit=1 to GRUB_CMDLINE_LINUX
		
		elif [[ $n = 4 ]]
		then	
			echo '4.1.1.4 Ensure audit_backlog_limit is sufficient'
			echo -e "${RED}Fail:	audit_backlog_limit is insufficient(recommended to  be 8192 or larger)${ENDCOLOR}"
#echo Fail: 4.1.1.$n #"Edit /etc/defaut/grub and add audit_backlog_limit=<BACKLOG SIZE> to GRUB_CMDLINE_LINUX"
		
		fi
	
		n=$(($n + 1))
failno=$(($failno + 1))

else
                if [[ $n = 3 ]]
                then
                        echo '4.1.1.3 Ensure auditing for processees that start prior to auditd is enabled'
                        echo -e "${GREEN}Pass:	auditing for processes that start prior to auditd is enabled${ENDCOLOR}"
#echo Fail: 4.1.1.$n #Edit /etc/default/grub and add audit=1 to GRUB_CMDLINE_LINUX

                elif [[ $n = 4 ]]
                then
                        echo '4.1.1.4 Ensure audit_backlog_limit is sufficient'
                        echo -e "${GREEN}Pass:	audit_backlog_limit is sufficient${ENDCOLOR}"
#echo Fail: 4.1.1.$n #"Edit /etc/defaut/grub and add audit_backlog_limit=<BACKLOG SIZE> to GRUB_CMDLINE_LINUX"

                fi

		echo "$n" > /dev/null
                n=$(($n + 1))
passno=$(($passno + 1))

	fi
done
echo

echo 4.1.2 Configure Data Retention

echo 4.1.2.1 Ensure aduit log storage size is configured
if [[ -n `grep max_log_file /etc/audit/auditd.conf` ]]
        then
                echo 'Important check:	Check if max_log_file parameter in /etc/audit/auditd.conf in accordance with site policy'
	else
		echo -e "${RED}Fail:	Audit log storage size is not configured${ENDCOLOR}"
        failno=$(($failno + 1))
	fi


echo 4.1.2.2 Ensure audit logs are not automatically deleted
if [[ -z `grep 'max_log_file_action = keep_logs' /etc/audit/auditd.conf` ]]
        then
                echo -e "${RED}Fail:	Audit logs are automatically deleted${ENDCOLOR}" #audit logs should not be automatically deleted
	#	echo Set the parameter 'max_log_file_action = keep_logs' in /etc/audit/auditd.conf
failno=$(($failno + 1))
else
	echo -e "${GREEN}Pass:	Audit logs are not automatically deleted${ENDCOLOR}"
passno=$(($passno + 1))
      
fi


echo 4.1.2.3 Ensure system is disabled when audit logs are full
check1=$(grep 'space_left_action = email' /etc/audit/auditd.conf)
check2=$(grep 'action_mail_acct = root' /etc/audit/auditd.conf)
check3=$(grep 'admin_space_left_action = halt' /etc/audit/auditd.conf)
	if [[ -z "$check1" || -z "$check2" || -z "$check3" ]]
	then
	echo -e "${RED}Fail:	System is not disabled when audit logs are full${ENDCOLOR}" #Set the parameters "'space_left_action = email'" "'action_mail_acct = root'" "'admin_space_left_action = halt'" in /etc/audit/auditd.conf 	
failno=$(($failno + 1))
else
	echo -e "${GREEN}Pass:	System is disabled when audit logs are full${ENDCOLOR}"
passno=$(($passno + 1))

fi


n=3
rules=('w.*sudoers.*scope' 'w.*(faillog|lastlog).*logins' 'w.*(utmp|wtmp|btmp).*(session|logins)' '(a|w).*(always|localtime).*time-change' 'w.*MAC-policy' '(a|w).*(arch|issue|hosts|sysconfig).*k.*system-locale')
for r in "${rules[@]}"
do
	check1=$(egrep -w "$r" /etc/audit/rules.d/*.rules)
	check2=$(auditctl -l | egrep -w "$r" /etc/audit/rules.d/*.rules)
	if [[ -z $check1 && $check1 = $check2 ]]
        then
		if [[ $n = 3 ]]
		then
			echo '4.1.3 Ensure changes to system administration scope(sudoers) is collected'
			echo -e "${RED}Fail:	Changes to sudoers are not collected${ENDCOLOR}"
		
		elif [[ $n = 4 ]]
		then
			echo '4.1.4 Ensure login and logout events are collected'
			echo -e "${RED}Fail:	Login and logout events are not collected${ENDCOLOR}"

		elif [[ $n = 5 ]]
		then
			echo '4.1.5 Ensure session initiation information is collected'
			echo -e "${RED}Fail:	Session initiation information is not collected${ENDCOLOR}" 

		elif [[ $n = 6 ]]
		then
			echo '4.1.6 Ensure events that modify date and time iformation are collected'
			echo -e "${RED}Fail:	Events that modify data dn time information are not collected${ENDCOLOR}"

		elif [[ $n = 7 ]]
		then
			echo '4.1.7 Ensure events that modify Mandatory Access Controls are collected'
			echo -e "${RED}Fail:	Events that modify system Mandatory Access Controls are not collected${ENDCOLOR}"

		elif [[ $n = 8 ]]
		then
			echo '4.1.8 Ensure events that modify the system network environment are collected'
			echo -e "${RED}Fail:	Events that modify the system network environment are not collected${ENDCOLOR}"
		
		fi
		n=$(($n + 1))
failno=$(($failno + 1))

        else
		if [[ $n = 3 ]]
		then
			echo '4.1.3 Ensure changes to system administration scope(sudoers) is collected'
			echo -e "${GREEN}Pass:	Changes to sudoers are collected${ENDCOLOR}" 
		
		elif [[ $n = 4 ]]
		then
			echo '4.1.4 Ensure login and logout events are collected'
			echo -e "${GREEN}Pass:	Login and logout events are collected${ENDCOLOR}" 

		elif [[ $n = 5 ]]
		then
			echo '4.1.5 Ensure session initiation information is collected'
			echo "${GREEN}Pass:	Session initiation information is collected" 

		elif [[ $n = 6 ]]
		then
			echo '4.1.6 Ensure events that modify date and time information are collected'
			echo -e "${GREEN}Pass:	Events that modify data dn time information are not collected${ENDCOLOR}"

		elif [[ $n = 7 ]]
		then
			echo '4.1.7 Ensure events that modify Mandatory Access Controls are collected'
			echo -e "${GREEN}Pass:	Events that modify system Mandatory Access Controls are collected${ENDCOLOR}"

		elif [[ $n = 8 ]]
		then
			echo '4.1.8 Ensure events that modify the system network environment are collected'
			echo -e "${GREEN}Pass:	Events that modify the system network environment are collected${ENDCOLOR}"
		
		fi
		echo $n > /dev/null
                n=$(($n + 1))
passno=$(($passno + 1))

	fi
done


n=9
rules2=(perm_mod access identity mounts)
for r in "${rules2[@]}"
do
        check1=$(egrep -w $r /etc/audit/rules.d/*.rules 2>/dev/null)
        check2=$(auditctl -l | grep $r)
        if [[ -z "$check1" ]] && [[ -z "$check2" ]]
        then

                if [[ $n = 9 ]]
                then
			echo  4.1.9 Ensure discretionary access control permission modification events are collected
                        echo -e "${RED}Fail:	Permission modification events are not collected${ENDCOLOR}" #Fix the stuff
		elif [[ $n = 10 ]]
		then
			echo 4.1.10 Ensure unsuccessful unauthorized file access attempts are collected
			echo -e "${RED}Fail:	unsuccessful unauthorised file access attempts are not collected${ENDCOLOR}"
               	elif [[ $n = 11 ]]
		then
			echo 4.1.11 Ensure events that modify user/group information are collected
			echo -e "${RED}Fail:	events that modify user/group info are not collected${ENDCOLOR}" #Fix the identity stuff
		elif [[ $n = 12 ]]
		then
			echo 4.1.12 Ensure successful file system mounts are collected
			echo -e "${RED}Fail:	successful file system mouns are not collected${ENDCOLOR}" #Fix the mounts stuff

		fi
                n=$(($n + 1))
        failno=$(($failno + 1))
	elif [[ -n "$check1" ]] && [[ -z "$check2" ]]
        then
		 if [[ $n = 9 ]]
                then
			echo  4.1.9 Ensure discretionary access control permission modification events are collected
                        echo -e "${RED}Fail:	Permission modification events are not collected${ENDCOLOR}" #Fix the stuff
		elif [[ $n = 10 ]]
		then
			echo 4.1.10 Ensure unsuccessful unauthorized file access attempts are collected
			echo -e "${RED}Fail:	unsuccessful unauthorised file access attempts are not collected${ENDCOLOR}"
               	elif [[ $n = 11 ]]
		then
			echo 4.1.11 Ensure events that modify user/group information are collected
			echo -e "${RED}Fail:	events that modify user/group info are not collected${ENDCOLOR}" #Fix the identity stuff
		elif [[ $n = 12 ]]
		then
			echo 4.1.12 Ensure successful file system mounts are collected
			echo -e "${RED}Fail:	successful file system mouns are not collected${ENDCOLOR}" #Fix the mounts stuff

		fi
               n=$(($n + 1))
failno=$(($failno + 1))
	elif [[ -z "$check1" ]] && [[ -n "$check2" ]]
        then
		if [[ $n = 9 ]]
                then
			echo  4.1.9 Ensure discretionary access control permission modification events are collected
                        echo -e "${RED}Fail:	Permission modification events are not collected${ENDCOLOR}" #Fix the stuff
		elif [[ $n = 10 ]]
		then
			echo 4.1.10 Ensure unsuccessful unauthorized file access attempts are collected
			echo -e "${RED}Fail:	unsuccessful unauthorised file access attempts are not collected${ENDCOLOR}"
               	elif [[ $n = 11 ]]
		then
			echo 4.1.11 Ensure events that modify user/group information are collected
			echo -e "${RED}Fail:	events that modify user/group info are not collected${ENDCOLOR}" #Fix the identity stuff
		elif [[ $n = 12 ]]
		then
			echo 4.1.12 Ensure successful file system mounts are collected
			echo -e "${RED}Fail:	successful file system mouns are not collected${ENDCOLOR}" #Fix the mounts stuff

		fi
               n=$(($n + 1))
failno=$(($failno + 1))

         else
                 if [[ $n = 9 ]]
                then
			echo  4.1.9 Ensure discretionary access control permission modification events are collected
                        echo -e "${GREEN}Pass:	Permission modification events are collected${ENDCOLOR}"
		elif [[ $n = 10 ]]
		then
			echo 4.1.10 Ensure unsuccessful unauthorized file access attempts are collected
			echo -e "${GREEN}Pass:	unsuccessful unauthorised file access attempts are collected${ENDCOLOR}"
               	elif [[ $n = 11 ]]
		then
			echo 4.1.11 Ensure events that modify user/group information are collected
			echo -e "${GREEN}Pass:	events that modify user/group info are collected${ENDCOLOR}" 
		elif [[ $n = 12 ]]
		then
			echo 4.1.12 Ensure successful file system mounts are collected
			echo -e "${GREEN}Pass:	successful file system mouns are collected${ENDCOLOR}"
		fi
		echo $n > /dev/null
		n=$(($n + 1))
passno=$(($passno + 1))

	fi
done



n=14
rules3=(delete modules)
for r in "${rules3[@]}"
do
        check1=$(egrep -w $r /etc/audit/rules.d/*.rules 2>/dev/null)
        check2=$(auditctl -l | grep $r)
        if [[ -z "$check1" ]] && [[ -z "$check2" ]]
        then

                if [[ $n = 14 ]]
                then
			echo '4.1.14 Ensure file detection events by users are collected'
                        echo -e "${RED}Fail:	File deletion events by users are not collected${ENDCOLOR}"
		elif [[ $n = 15 ]]
		then
			echo 4.1.15 Ensure kernel module loading and unloading is collected
			echo -e "${RED}Fail:	insmod, rmmod and modprobe are not set${ENDCOLOR}"
               
		fi
                n=$(($n + 1))
		failno=$(($failno + 1))
        elif [[ -n "$check1" ]] && [[ -z "$check2" ]]
        then

                if [[ $n = 14 ]]
                then
			echo '4.1.14 Ensure file detection events by users are collected'
                        echo -e "${RED}Fail:	File deletion events by users are not collected${ENDCOLOR}"

		elif [[ $n = 15 ]]
                then
                        echo 4.1.15 Ensure kernel module loading and unloading is collected
                        echo -e "${RED}Fail:     insmod, rmmod and modprobe are not set${ENDCOLOR}"

	 
		fi
                n=$(($n + 1))
failno=$(($failno + 1))
	elif [[ -z "$check1" ]] && [[ -n "$check2" ]]
        then

                if [[ $n = 14 ]]
                then
                        
			echo '4.1.14 Ensure file detection events by users are collected'
                        echo -e "${RED}Fail:	File deletion events by users are not collected${ENDCOLOR}"


                elif [[ $n = 15 ]]
                then
                        echo 4.1.15 Ensure kernel module loading and unloading is collected
                        echo -e "${RED}Fail:     insmod, rmmod and modprobe are not set${ENDCOLOR}"


		fi
                n=$(($n + 1))
failno=$(($failno + 1))

         else
		if [[ $n = 14 ]]
                then
                        
			echo '4.1.14 Ensure file detection events by users are collected'
                        echo -e "${RED}Fail:	File deletion events by users are not collected${ENDCOLOR}"


                elif [[ $n = 15 ]]
                then
                        echo 4.1.15 Ensure kernel module loading and unloading is collected
                        echo -e "${RED}Fail:     insmod, rmmod and modprobe are not set${ENDCOLOR}"


		fi
		echo $n > /dev/null
		n=$(($n + 1))
passno=$(($passno + 1))

	fi
done

echo 4.1.17 Ensure the audit configuration is immutable
if [[ -z $(grep "^\s*[^#]" /etc/audit/rules.d/*.rules | grep -- "-e 2") ]]
then
	echo -e "${RED}Fail:	Audit configuration is not immutable${ENDCOLOR}"  #Edit or create the file /etc/audit/rules.d/99-finalize.rulesand add the line "-e 2"
failno=$(($failno + 1))
else
	echo -e "${GREEN}Pass:	Audit configuration is immutable${ENDCOLOR}"
passno=$(($passno + 1))

fi

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
echo NUMBER OF PASSES: $passno
echo NUMBER OF FAILED: $failno
