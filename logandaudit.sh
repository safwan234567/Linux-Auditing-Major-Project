#! /bin/bash
passno=0
failno=0

echo
echo 4.1.1 Ensure auditing is enabled

echo 4.1.1.1 Ensure auditd is installed
if [[ -z `rpm -q audit audit-libs | grep audit-` ]]
then
	echo 'Fail:	auditd is not installed'
failno=$(($failno + 1))

else
	echo 'Pass:	auditd is installed'
passno=$(($passno + 1))

fi

echo 4.1.1.2 Ensure auditd service is enabled
if [[ `systemctl is-enabled auditd 2>/dev/null` != 'enabled' ]]
        then
        echo 'Fail:	auditd service is not enabled'
failno=$(($failno + 1))
else
	echo 'Pass:	auditd service is enabled'
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
			echo 'Fail:	auditing for processes that start prior to auditd is dis:abled'
#echo Fail: 4.1.1.$n #Edit /etc/default/grub and add audit=1 to GRUB_CMDLINE_LINUX
		
		elif [[ $n = 4 ]]
		then	
			echo '4.1.1.4 Ensure audit_backlog_limit is sufficient'
			echo 'Fail:	audit_backlog_limit is insufficient(recommended to  be 8192 or larger)'
#echo Fail: 4.1.1.$n #"Edit /etc/defaut/grub and add audit_backlog_limit=<BACKLOG SIZE> to GRUB_CMDLINE_LINUX"
		
		fi
	
		n=$(($n + 1))
failno=$(($failno + 1))

else
                if [[ $n = 3 ]]
                then
                        echo '4.1.1.3 Ensure auditing for processees that start prior to auditd is enabled'
                        echo 'Pass:	auditing for processes that start prior to auditd is enabled'
#echo Fail: 4.1.1.$n #Edit /etc/default/grub and add audit=1 to GRUB_CMDLINE_LINUX

                elif [[ $n = 4 ]]
                then
                        echo '4.1.1.4 Ensure audit_backlog_limit is sufficient'
                        echo 'Pass:	audit_backlog_limit is sufficient'
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
		echo 'Fail:	Audit log storage size is not configured' #audit log storage size is NOT configured
        failno=$(($failno + 1))
	fi


echo 4.1.2.2 Ensure audit logs are not automatically deleted
if [[ -z `grep 'max_log_file_action = keep_logs' /etc/audit/auditd.conf` ]]
        then
                echo 'Fail:	Audit logs are automatically deleted' #audit logs should not be automatically deleted
	#	echo Set the parameter 'max_log_file_action = keep_logs' in /etc/audit/auditd.conf
failno=$(($failno + 1))
else
	echo 'Pass:	Audit logs are not automatically deleted'
passno=$(($passno + 1))
      
fi


echo 4.1.2.3 Ensure system is disabled when audit logs are full
check1=$(grep 'space_left_action = email' /etc/audit/auditd.conf)
check2=$(grep 'action_mail_acct = root' /etc/audit/auditd.conf)
check3=$(grep 'admin_space_left_action = halt' /etc/audit/auditd.conf)
	if [[ -z "$check1" || -z "$check2" || -z "$check3" ]]
	then
	echo 'Fail:	System is not disabled when audit logs are full' #Set the parameters "'space_left_action = email'" "'action_mail_acct = root'" "'admin_space_left_action = halt'" in /etc/audit/auditd.conf 	
failno=$(($failno + 1))
else
	echo 'Pass:	System is disabled when audit logs are full'
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
			echo 'Fail:	Changes to sudoers are not collected' 
		
		elif [[ $n = 4 ]]
		then
			echo '4.1.4 Ensure login and logout events are collected'
			echo 'Fail:	Login and logout events are not collected' 

		elif [[ $n = 5 ]]
		then
			echo '4.1.5 Ensure session initiation information is collected'
			echo 'Fail:	Session initiation information is not collected' 

		elif [[ $n = 6 ]]
		then
			echo '4.1.6 Ensure events that modify date and time iformation are collected'
			echo 'Fail:	Events that modify data dn time information are not collected'

		elif [[ $n = 7 ]]
		then
			echo '4.1.7 Ensure events that modify Mandatory Access Controls are collected'
			echo 'Fail:	Events that modify system Mandatory Access Controls are not collected'

		elif [[ $n = 8 ]]
		then
			echo '4.1.8 Ensure events that modify the system network environment are collected'
			echo 'Fail:	Events that modify the system network environment are not collected'
		
		fi
		n=$(($n + 1))
failno=$(($failno + 1))

        else
		if [[ $n = 3 ]]
		then
			echo '4.1.3 Ensure changes to system administration scope(sudoers) is collected'
			echo 'Pass:	Changes to sudoers are collected' 
		
		elif [[ $n = 4 ]]
		then
			echo '4.1.4 Ensure login and logout events are collected'
			echo 'Pass:	Login and logout events are collected' 

		elif [[ $n = 5 ]]
		then
			echo '4.1.5 Ensure session initiation information is collected'
			echo 'Pass:	Session initiation information is collected' 

		elif [[ $n = 6 ]]
		then
			echo '4.1.6 Ensure events that modify date and time information are collected'
			echo 'Pass:	Events that modify data dn time information are not collected'

		elif [[ $n = 7 ]]
		then
			echo '4.1.7 Ensure events that modify Mandatory Access Controls are collected'
			echo 'Pass:	Events that modify system Mandatory Access Controls are collected'

		elif [[ $n = 8 ]]
		then
			echo '4.1.8 Ensure events that modify the system network environment are collected'
			echo 'Pass:	Events that modify the system network environment are collected'
		
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
                        echo 'Fail:	Permission modification events are not collected' #Fix the stuff
		elif [[ $n = 10 ]]
		then
			echo 4.1.10 Ensure unsuccessful unauthorized file access attempts are collected
			echo 'Fail:	unsuccessful unauthorised file access attempts are not collected'
               	elif [[ $n = 11 ]]
		then
			echo 4.1.11 Ensure events that modify user/group information are collected
			echo 'Fail:	events that modify user/group info are not collected' #Fix the identity stuff
		elif [[ $n = 12 ]]
		then
			echo 4.1.12 Ensure successful file system mounts are collected
			echo 'Fail:	successful file system mouns are not collected' #Fix the mounts stuff

		fi
                n=$(($n + 1))
        failno=$(($failno + 1))
	elif [[ -n "$check1" ]] && [[ -z "$check2" ]]
        then
		 if [[ $n = 9 ]]
                then
			echo  4.1.9 Ensure discretionary access control permission modification events are collected
                        echo 'Fail:	Permission modification events are not collected' #Fix the stuff
		elif [[ $n = 10 ]]
		then
			echo 4.1.10 Ensure unsuccessful unauthorized file access attempts are collected
			echo 'Fail:	unsuccessful unauthorised file access attempts are not collected'
               	elif [[ $n = 11 ]]
		then
			echo 4.1.11 Ensure events that modify user/group information are collected
			echo 'Fail:	events that modify user/group info are not collected' #Fix the identity stuff
		elif [[ $n = 12 ]]
		then
			echo 4.1.12 Ensure successful file system mounts are collected
			echo 'Fail:	successful file system mouns are not collected' #Fix the mounts stuff

		fi
               n=$(($n + 1))
failno=$(($failno + 1))
	elif [[ -z "$check1" ]] && [[ -n "$check2" ]]
        then
		if [[ $n = 9 ]]
                then
			echo  4.1.9 Ensure discretionary access control permission modification events are collected
                        echo 'Fail:	Permission modification events are not collected' #Fix the stuff
		elif [[ $n = 10 ]]
		then
			echo 4.1.10 Ensure unsuccessful unauthorized file access attempts are collected
			echo 'Fail:	unsuccessful unauthorised file access attempts are not collected'
               	elif [[ $n = 11 ]]
		then
			echo 4.1.11 Ensure events that modify user/group information are collected
			echo 'Fail:	events that modify user/group info are not collected' #Fix the identity stuff
		elif [[ $n = 12 ]]
		then
			echo 4.1.12 Ensure successful file system mounts are collected
			echo 'Fail:	successful file system mouns are not collected' #Fix the mounts stuff

		fi
               n=$(($n + 1))
failno=$(($failno + 1))

         else
                 if [[ $n = 9 ]]
                then
			echo  4.1.9 Ensure discretionary access control permission modification events are collected
                        echo 'Pass:	Permission modification events are collected' 
		elif [[ $n = 10 ]]
		then
			echo 4.1.10 Ensure unsuccessful unauthorized file access attempts are collected
			echo 'Pass:	unsuccessful unauthorised file access attempts are collected'
               	elif [[ $n = 11 ]]
		then
			echo 4.1.11 Ensure events that modify user/group information are collected
			echo 'Pass:	events that modify user/group info are collected' 
		elif [[ $n = 12 ]]
		then
			echo 4.1.12 Ensure successful file system mounts are collected
			echo 'Pass:	successful file system mouns are collected'
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
                        echo 'Fail:	File deletion events by users are not collected'
		elif [[ $n = 15 ]]
		then
			echo 4.1.15 Ensure kernel module loading and unloading is collected
			echo 'Fail:	insmod, rmmod and modprobe are not set'
               
		fi
                n=$(($n + 1))
		failno=$(($failno + 1))
        elif [[ -n "$check1" ]] && [[ -z "$check2" ]]
        then

                if [[ $n = 14 ]]
                then
			echo '4.1.14 Ensure file detection events by users are collected'
                        echo 'Fail:	File deletion events by users are not collected'

		elif [[ $n = 15 ]]
                then
                        echo 4.1.15 Ensure kernel module loading and unloading is collected
                        echo 'Fail:     insmod, rmmod and modprobe are not set'

	 
		fi
                n=$(($n + 1))
failno=$(($failno + 1))
	elif [[ -z "$check1" ]] && [[ -n "$check2" ]]
        then

                if [[ $n = 14 ]]
                then
                        
			echo '4.1.14 Ensure file detection events by users are collected'
                        echo 'Fail:	File deletion events by users are not collected'


                elif [[ $n = 15 ]]
                then
                        echo 4.1.15 Ensure kernel module loading and unloading is collected
                        echo 'Fail:     insmod, rmmod and modprobe are not set'


		fi
                n=$(($n + 1))
failno=$(($failno + 1))

         else
		if [[ $n = 14 ]]
                then
                        
			echo '4.1.14 Ensure file detection events by users are collected'
                        echo 'Fail:	File deletion events by users are not collected'


                elif [[ $n = 15 ]]
                then
                        echo 4.1.15 Ensure kernel module loading and unloading is collected
                        echo 'Fail:     insmod, rmmod and modprobe are not set'


		fi
		echo $n > /dev/null
		n=$(($n + 1))
passno=$(($passno + 1))

	fi
done

echo 4.1.17 Ensure the audit configuration is immutable
if [[ -z $(grep "^\s*[^#]" /etc/audit/rules.d/*.rules | grep -- "-e 2") ]]
then
	echo 'Fail:	Audit configuration is not immutable'  #Edit or create the file /etc/audit/rules.d/99-finalize.rulesand add the line "-e 2"
failno=$(($failno + 1))
else
	echo 'Pass:	Audit configuration is immutable'
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
	echo 'Pass:	rsyslog is installed'
passno=$(($passno + 1))

else
	echo 'Fail:	rsyslog is not installed' #Run the following command to install rsyslog: # dnf install rsyslog
failno=$(($failno + 1))
fi

echo 4.2.1.2 Ensure rsyslog Service is installed
if [[ `systemctl is-enabled rsyslog` != 'enabled' ]]
then
	echo 'Fail:	rsyslog Service is not installed' #Run the following command to enable rsyslog: # systemctl --now enable rsyslog
failno=$(($failno + 1))
else
	echo 'Pass:	rsyslog Service is installed'
passno=$(($passno + 1))

fi

echo 4.2.1.3 Ensure rsyslog default file permissions configured
check=$(grep ^\$FileCreateMode /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null | egrep "(0640||0600)")
if [[ -z $check ]]
then
	echo 'Fail:	$FileCreateMode is not 0640 or more restrictive' #Edit the /etc/rsyslog.conf and /etc/rsyslog.d/*.conf files and set $FileCreateModeto 0640 or more restrictive:"$FileCreateMode 0640"'
failno=$(($failno + 1))
else
	echo 'Pass:	$FileCreateMode is 0640 or more restrictive'
passno=$(($passno + 1))

fi


echo 4.2.1.4 Ensure logging is configured
if [[ -z `ls -l /var/log/` ]]
then
	echo 'Fail:	logging is not configured' #Edit the following lines in the /etc/rsyslog.confand /etc/rsyslog.d/*.conffiles
failno=$(($failno + 1))
else
	echo 'Pass:	logging is configured (Check /etc/rsyslog.conf and /etc/rsyslog.d/*.conf and edit the lines as appropriate for your environment)'
passno=$(($passno + 1))

fi


echo 4.2.1.5 Ensure rsyslog is configured to send logs to a remote log host
if [[ -z `grep "^*.*[^I][^I]*@" /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null` ]]
then
	echo 'Fail:	rysyslog is not configured to send logs to a remote log host' #Edit the /etc/rsyslog.conf and /etc/rsyslog.d/*.conf files and add the following line (where loghost.example.com is the name of your central log host). *.* @@loghost.example.com  then run the following command to reload the rsyslogd configuration: # systemctl restart rsyslog'
failno=$(($failno + 1))
else
	echo 'Pass:	rsyslog sends logs to remote log host'
passno=$(($passno + 1))

fi

echo
echo 4.2.2 Configure Journald
echo

echo 4.2.2.1 Ensure journald is configured to send logs to rsyslog
if [[ `grep -e ^\s*ForwardToSyslog /etc/systemd/journald.conf` != 'ForwardToSyslog=yes' ]]
then
	echo 'Fail:	journald does not forward logs to syslog' #Edit the /etc/systemd/journald.conf file and add the following line: ForwardToSyslog=yes
failno=$(($failno + 1))
else
	echo 'Pass:	journald forwards logs to syslog'
passno=$(($passno + 1))

fi

echo 4.2.2.2 Ensure journald is configured to compress large log files
if [[ `grep -e ^\s*Compress /etc/systemd/journald.conf` != 'Compress=yes' ]]
then
	echo 'Fail:	journald is not configured to compress larger files' #Edit the /etc/systemd/journald.conf file and add the following line: Compress=yes
failno=$(($failno + 1))
else
	echo 'Pass:	journald is set to compress large files'
passno=$(($passno + 1))

fi

echo 4.2.2.3 Ensure journald is configured to write logfiles to persistent disk
if [[ `grep -e ^\s*Storage /etc/systemd/journald.conf` != 'Storage=persistent' ]]
then
	echo 'Fail:	logs are not persisted to disk' #Edit the /etc/systemd/journald.conf file and add the following line: Storage=persistent
failno=$(($failno + 1))
else
	echo 'Pass:	logs are persisted to disk'
passno=$(($passno + 1))

fi

echo 4.2.3 Ensure permissions on all logfiles are configured
if [[ -n `find /var/log -type f -perm /037 -ls -o -type d -perm /026 -ls` ]]
then
	echo 'Fail:	Other has permissions on some files and Group has write or execute permissions on some files' #Run the following commands to set permissions on all existing log files: find /var/log -type f -exec chmod g-wx,o-rwx "{}" + -o -type d -exec chmod g-w,o-rwx "{}" +
failno=$(($failno + 1))
else
	echo 'Pass:	permissions are configured'
passno=$(($passno + 1))

fi

echo
echo NUMBER OF PASSES: $passno
echo NUMBER OF FAILED: $failno
