#! /bin/bash

echo
echo 4.1.1 Ensure auditing is enabled

if [[ -z `rpm -q audit audit-libs | grep audit-` ]]
then
	echo Fail: 4.1.1.1 auditd is not installed
fi

if [[ `systemctl is-enabled auditd 2>/dev/null` != 'enabled' ]]
        then
        echo Fail: 4.1.1.2 auditd service is not enabled
fi


n=3
perim=('kernelopts=(\S+\s+)*audit=1\b' 'kernelopts=(\S+\s+)*audit_backlog_limit=\S+\b')
for p in "${perim[@]}"
do

        if [[ -z `grep -E $p /boot/grub2/grubenv` ]]
        then
                           
		if [[ $n = 3 ]]
		then
			echo Fail: 4.1.1.$n Edit /etc/default/grub and add audit=1 to GRUB_CMDLINE_LINUX
		
		elif [[ $n = 4 ]]
		then
			echo Fail: 4.1.1.$n "Edit /etc/defaut/grub and add audit_backlog_limit=<BACKLOG SIZE> to GRUB_CMDLINE_LINUX"
		
		fi
		n=$(($n + 1))

        else
                echo "$n" > /dev/null
                n=$(($n + 1))
        fi
done
echo

echo 4.1.2 Configure Data Retention

if [[ -n `grep max_log_file /etc/audit/auditd.conf` ]]
        then
                echo Important check: 4.1.2.1 Set the max_log_file parameter in /etc/audit/auditd.conf in accordance with site policy
	else
		echo Fail: 4.1.2.1 audit log storage size is NOT configured
        fi

echo

if [[ -z `grep 'max_log_file_action = keep_logs' /etc/audit/auditd.conf` ]]
        then
                echo Fail: 4.1.2.2 audit logs should not be automatically deleted
		echo Set the parameter 'max_log_file_action = keep_logs' in /etc/audit/auditd.conf
        fi

echo

check1=$(grep 'space_left_action = email' /etc/audit/auditd.conf)
check2=$(grep 'action_mail_acct = root' /etc/audit/auditd.conf)
check3=$(grep 'admin_space_left_action = halt' /etc/audit/auditd.conf)
	if [[ -z "$check1" || -z "$check2" || -z "$check3" ]]
	then
	echo Fail: 4.1.2.3 Set the parameters "'space_left_action = email'" "'action_mail_acct = root'" "'admin_space_left_action = halt'" in /etc/audit/auditd.conf 	
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
			echo Fail: 4.1.$n Fix the stuff 
		
		elif [[ $n = 4 ]]
		then
			echo Fail: 4.1.$n Fix the stuff

		elif [[ $n = 5 ]]
		then
			echo Fail: 4.1.$n Fix the stuff

		elif [[ $n = 6 ]]
		then
			echo Fail: 4.1.$n Fix the stuff

		elif [[ $n = 7 ]]
		then
			echo Fail: 4.1.$n Fix theMAC stuff

		elif [[ $n = 8 ]]
		then
			echo Fail: 4.1.$n Fix the stuff
		
		fi
		n=$(($n + 1))


        else
		echo $n > /dev/null
                n=$(($n + 1))
        fi
done

echo
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
                        echo Fail: 4.1.$n Fix the stuff
		elif [[ $n = 10 ]]
		then
			echo Fail: 4.1.$n Fix the access stuff
               	elif [[ $n = 11 ]]
		then
			echo Fail: 4.1.$n Fix the identity stuff
		elif [[ $n = 12 ]]
		then
			echo Fail: 4.1.$n Fix the mounts stuff

		fi
                n=$(($n + 1))
        elif [[ -n "$check1" ]] && [[ -z "$check2" ]]
        then

                if [[ $n = 9 ]]
                then
                        echo Fail: 4.1.$n Restart your computer
                elif [[ $n = 10 ]]
                then
                        echo Fail: 4.1.$n Restart your computer
                elif [[ $n = 11 ]]
                then
                        echo Fail: 4.1.$n Restart your computer
                elif [[ $n = 12 ]]
                then
                        echo Fail: 4.1.$n Restart your computer
		
		fi
                n=$(($n + 1))
	elif [[ -z "$check1" ]] && [[ -n "$check2" ]]
        then

                if [[ $n = 9 ]]
                then
                        echo Fail: 4.1.$n Restart your computer
                elif [[ $n = 10 ]]
                then
                        echo Fail: 4.1.$n Restart your computer
                elif [[ $n = 11 ]]
                then
                        echo Fail: 4.1.$n Restart your computer
                elif [[ $n = 12 ]]
                then
                        echo Fail: 4.1.$n Restart your computer
	
		fi
                n=$(($n + 1))


         else
                echo $n > /dev/null
		n=$(($n + 1))
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
                        echo Fail: 4.1.$n Fix delete stuff
		elif [[ $n = 15 ]]
		then
			echo Fail: 4.1.$n Fix the modules stuff
               
		fi
                n=$(($n + 1))
        elif [[ -n "$check1" ]] && [[ -z "$check2" ]]
        then

                if [[ $n = 14 ]]
                then
                        echo Fail: 4.1.$n Fix the stuff
                elif [[ $n = 15 ]]
                then
                        echo Fail: 4.1.$n Fix the stuff
	
		fi
                n=$(($n + 1))
	elif [[ -z "$check1" ]] && [[ -n "$check2" ]]
        then

                if [[ $n = 14 ]]
                then
                        echo Fail: 4.1.$n Fix the stuff
                elif [[ $n = 15 ]]
                then
                        echo Fail: 4.1.$n Fix the stuff

		fi
                n=$(($n + 1))


         else
                echo $n > /dev/null
		n=$(($n + 1))
        fi
done


if [[ -z $(grep "^\s*[^#]" /etc/audit/rules.d/*.rules | grep -- "-e 2") ]]
then
	echo 'Fail: 4.1.17 Edit or create the file /etc/audit/rules.d/99-finalize.rulesand add the line "-e 2"'
fi


if [[ `rpm -q rsyslog` =~ 'rsyslog' ]]
then
	echo null > /dev/null
else
	echo 'Fail: 4.2.1.1 Run the following command to install rsyslog: # dnf install rsyslog'
fi

if [[ `systemctl is-enabled rsyslog` != 'enabled' ]]
then
	echo 'Fail: 4.2.1.2 Run the following command to enable rsyslog: # systemctl --now enable rsyslog'
fi

check=$(grep ^\$FileCreateMode /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null | egrep "(0640||0600)")
if [[ -z $check ]]
then
	echo 'Fail: 4.2.1.3 Edit the /etc/rsyslog.conf and /etc/rsyslog.d/*.conf files and set $FileCreateModeto 0640 or more restrictive:"$FileCreateMode 0640"'
fi



if [[ -z `ls -l /var/log/` ]]
then
	echo Fail: 4.2.1.4 Edit the following lines in the /etc/rsyslog.confand /etc/rsyslog.d/*.conffiles
fi



if [[ -z `grep "^*.*[^I][^I]*@" /etc/rsyslog.conf /etc/rsyslog.d/*.conf` ]]
then
	echo 'Fail: 4.2.1.5 Edit the /etc/rsyslog.conf and /etc/rsyslog.d/*.conf files and add the following line (where loghost.example.com is the name of your central log host). *.* @@loghost.example.com  then run the following command to reload the rsyslogd configuration: # systemctl restart rsyslog'
fi

echo
echo 4.2.2 Configure Journald

if [[ `grep -e ^\s*ForwardToSyslog /etc/systemd/journald.conf` != 'ForwardToSyslog=yes' ]]
then
	echo Fail: 4.2.2.1 Edit the /etc/systemd/journald.conf file and add the following line: ForwardToSyslog=yes
fi

if [[ `grep -e ^\s*Compress /etc/systemd/journald.conf` != 'Compress=yes' ]]
then
	echo Fail: 4.2.2.2 Edit the /etc/systemd/journald.conf file and add the following line: Compress=yes
fi

if [[ `grep -e ^\s*Storage /etc/systemd/journald.conf` != 'Storage=persistent' ]]
then
	echo Fail 4.2.2.3 Edit the /etc/systemd/journald.conf file and add the following line: Storage=persistent
fi

if [[ -n `find /var/log -type f -perm /037 -ls -o -type d -perm /026 -ls` ]]
then
	echo Fail: 4.2.3 Run the following commands to set permissions on all existing log files: find /var/log -type f -exec chmod g-wx,o-rwx "{}" + -o -type d -exec chmod g-w,o-rwx "{}" +
fi

