#! /bin/bash


if [[ $(id -u) != 0 ]]
then
        echo Ensure you are logged into root and log out of all other accounts
else

cat .banner
sudo yum -y install python3 > /dev/null
sudo  yum -y install python3-pip > /dev/null
pip3 -q install pandas > /dev/null
pip3 -q install matplotlib > /dev/null

level2s() {
passno=0
failno=0
RED="\e[91m"
GREEN="\e[92m"
ENDCOLOR='\e[0m'

echo
echo -----------------------------
date
echo -----------------------------
echo LEVEL 2 SERVER AUDIT
echo



echo CHAPTER 1 : INITIAL SETUP
echo
echo "1.1.1.2: Ensure mounting of vFAT filesystems is limited"
if [[ `modprobe -n -v vfat` != "install /bin/true" ]]
        then
            	echo -e "${RED}Fail:	vFAT is not configured properly	(PAGE 24)${ENDCOLOR}"
                failno=$(($failno + 1))

elif [[ -n `lsmod | grep vfat` ]]
                then
                    	echo -e "${RED}Fail:	vFAT is not configured properly (PAGE 24)${ENDCOLOR}"
                        failno=$(($failno + 1))

else
    	echo -e "${GREEN}Pass:	vFAT is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi #something went wrong here

echo "1.1.6 Ensure separate partition exists for /var "
if [[ -z `mount | grep -E '\s/var\s'` ]]
        then 
             	echo -e "${RED}Fail:	Seperate partition does not exist	(PAGE 39)${ENDCOLOR}"
                failno=$(($failno + 1))
else
        echo -e "${GREEN}Pass:	/var is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.7 Ensure separate partition exists for /var/tmp"
if [[ -z `mount | grep /var/tmp` ]]
        then
            	echo -e "${RED}Fail:	Seperation partition does not exist	(PAGE 41)${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo -e "${GREEN}Pass:	/var/tmp is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.11 Ensure separate partition exists for /var/log "
if [[ -z `mount | grep /var/log` ]]
        then
            	echo -e "${RED}Fail:	Seperate partion does not exist for /var/log	(PAGE 46)${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo -e "${GREEN}Pass:	/var/log is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.12 Ensure separate partition exists for /var/log/audit "
if [[ -z `mount | grep /var/log/audit` ]]
        then
            	echo -e "${RED}Fail:	Seperate partition does not exist for /var/log/audit	(PAGE 48)${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	echo -e "${GREEN}Pass:	/var/log/audit is configured properly${ENDCOLOR}"
        passno=$(($passno + 1))
fi

echo "1.1.13 Ensure separate partition exists for /home "
if [[ -z `mount | grep /home` ]]
        then
            	echo -e "${RED}Fail:	Seperate partition does not exist for /home	(PAGE 50)${ENDCOLOR}"
                failno=$(($failno + 1))
else
    	passno=$(($passno + 1))
        echo -e "${GREEN}Pass:	/home is configured properly${ENDCOLOR}"
fi
echo END OF CHAPTER 1
echo
#-----------------------------------------------
echo CHAPTER 3 : NETWORK CONFIGURATION
echo 
echo 3.3 Uncommon Network Protocols
echo 3.3.1 Ensure DCCP is disabled
#3.3.1
if ! modprobe -n -v dccp 2> /dev/null | tail -1 | grep -q 'install /bin/true'
        then
                echo -e "${RED}Fail:	DCCP is not disabled	(PAGE 198)${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:	DCCP is disabled${ENDCOLOR}"
                passno=$(($passno + 1))
        fi


echo 3.3.2 Ensure SCTP is disabled
#3.3.2
if ! modprobe -n -v sctp 2> /dev/null | tail -1 | grep -q 'install /bin/true'
        then
                echo -e "${RED}Fail:	SCTP is not disabled	(PAGE 199)${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:	SCTP is disabled${ENDCOLOR}"
                passno=$(($passno + 1))
        fi


echo 3.3.3 Ensure RDS is disabled
#3.3.3
if ! modprobe -n -v rds 2> /dev/null | tail -1 | grep -q 'install /bin/true'
        then
                echo -e "${RED}Fail:	RDS is not disabled	(PAGE 200)${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:	RDS is disabled${ENDCOLOR}"
                passno=$(($passno + 1))
        fi


echo 3.3.4 Ensure TIPC is disabled
#3.3.4
if ! modprobe -n -v tipc 2> /dev/null | tail -1 | grep -q 'install /bin/true'
        then
                echo -e "${RED}Fail:	TIPC is not disabled	(PAGE 201)${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:	TIPC is disabled${ENDCOLOR}"
                passno=$(($passno + 1))
        fi


echo 3.6 Disable IPv6
#3.6
ipv6disable=$(grep -E "^\s*kernelopts=(\S+\s+)*ipv6\.disable=1\b\s*(\S+\s*)*$" /boot/grub2/grubenv)
        if [[ -z $ipv6disable ]]
        then
                echo -e "${RED}Fail:	IPv6 is not disabled	(PAGE 263)${ENDCOLOR}"
                failno=$(($failno + 1))
        else
                echo -e "${GREEN}Pass:	IPv6 is disabled${ENDCOLOR}"
                passno=$(($passno + 1))
        fi
#-----------------------------------------------
#CHAP 4
echo
echo CHAPTER 4 LOGGING AND AUDITING
echo
echo 4.1.1 Ensure auditing is enabled

echo 4.1.1.1 Ensure auditd is installed
if [[ -z `rpm -q audit audit-libs | grep audit-` ]]
then
	echo -e "${RED}Fail:	auditd is not installed	(PAGE 267)${ENDCOLOR}"
failno=$(($failno + 1))

else
	echo -e "${GREEN}Pass:	auditd is installed${ENDCOLOR}"
passno=$(($passno + 1))

fi

echo 4.1.1.2 Ensure auditd service is enabled
if [[ `sys2emctl is-enabled auditd 2>/dev/null` != 'enabled' ]]
        then
		echo -e "${RED}Fail:	auditd service is not enabled	(PAGE 268)${ENDCOLOR}"
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
			echo -e "${RED}Fail:	auditing for processes that start prior to auditd is disabled	(PAGE 270)${ENDCOLOR}"
#echo Fail: 4.1.1.$n #Edit /etc/default/grub and add audit=1 to GRUB_CMDLINE_LINUX
		
		elif [[ $n = 4 ]]
		then	
			echo '4.1.1.4 Ensure audit_backlog_limit is sufficient'
			echo -e "${RED}Fail:	audit_backlog_limit is insufficient(recommended to  be 8192 or larger)	(PAGE 272)${ENDCOLOR}"
#echo Fail: 4.1.1.$n #"Edit /etc/defaut/grub and add audit_backlog_limit=<BACKLOG SIZE> to GRUB_CMDLINE_LINUX"
		
		fi
	
		n=$(($n + 1))
failno=$(($failno + 1))

else
                if [[ $n = 3 ]]
                then
                        echo '4.1.1.3 Ensure auditing for processees that start prior to auditd is enabled'
                        echo -e "${GREEN}Pass:	auditing for processes that start prior to auditd is enabled${ENDCOLOR}"

                elif [[ $n = 4 ]]
                then
                        echo '4.1.1.4 Ensure audit_backlog_limit is sufficient'
                        echo -e "${GREEN}Pass:	audit_backlog_limit is sufficient${ENDCOLOR}"

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
		echo -e "${RED}Fail:	Audit log storage size is not configured	(PAGE 275)${ENDCOLOR}"
        failno=$(($failno + 1))
	fi


echo 4.1.2.2 Ensure audit logs are not automatically deleted
if [[ -z `grep 'max_log_file_action = keep_logs' /etc/audit/auditd.conf` ]]
        then
		echo -e "${RED}Fail:	Audit logs are automatically deleted	(PAGE 277)${ENDCOLOR}" #audit logs should not be automatically deleted
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
		echo -e "${RED}Fail:	System is not disabled when audit logs are full	(PAGE 278)${ENDCOLOR}" #Set the parameters "'space_left_action = email'" "'action_mail_acct = root'" "'admin_space_left_action = halt'" in /etc/audit/auditd.conf 	
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
			echo -e "${RED}Fail:	Changes to sudoers are not collected	(PAGE 279)${ENDCOLOR}"
		
		elif [[ $n = 4 ]]
		then
			echo '4.1.4 Ensure login and logout events are collected'
			echo -e "${RED}Fail:	Login and logout events are not collected	(PAGE 281)${ENDCOLOR}"

		elif [[ $n = 5 ]]
		then
			echo '4.1.5 Ensure session initiation information is collected'
			echo -e "${RED}Fail:	Session initiation information is not collected	(PAGE 283)${ENDCOLOR}" 

		elif [[ $n = 6 ]]
		then
			echo '4.1.6 Ensure events that modify date and time iformation are collected'
			echo -e "${RED}Fail:	Events that modify data dn time information are not collected	(PAGE 285)${ENDCOLOR}"

		elif [[ $n = 7 ]]
		then
			echo '4.1.7 Ensure events that modify Mandatory Access Controls are collected'
			echo -e "${RED}Fail:	Events that modify system Mandatory Access Controls are not collected	(PAGE 287)${ENDCOLOR}"

		elif [[ $n = 8 ]]
		then
			echo '4.1.8 Ensure events that modify the system network environment are collected'
			echo -e "${RED}Fail:	Events that modify the system network environment are not collected	(PAGE 289)${ENDCOLOR}"
		
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
			echo -e "${RED}Fail:	Permission modification events are not collected	(PAGE 291)${ENDCOLOR}" 
		elif [[ $n = 10 ]]
		then
			echo 4.1.10 Ensure unsuccessful unauthorized file access attempts are collected
			echo -e "${RED}Fail:	unsuccessful unauthorised file access attempts are not collected	(PAGE 294)${ENDCOLOR}"
               	elif [[ $n = 11 ]]
		then
			echo 4.1.11 Ensure events that modify user/group information are collected
			echo -e "${RED}Fail:	events that modify user/group info are not collected	(PAGE 297)${ENDCOLOR}" 
		elif [[ $n = 12 ]]
		then
			echo 4.1.12 Ensure successful file system mounts are collected
			echo -e "${RED}Fail:	successful file system mouns are not collected	(PAGE 299)${ENDCOLOR}" 

		fi
                n=$(($n + 1))
        failno=$(($failno + 1))
	elif [[ -n "$check1" ]] && [[ -z "$check2" ]]
        then
		 if [[ $n = 9 ]]
                then
			echo  4.1.9 Ensure discretionary access control permission modification events are collected
			echo -e "${RED}Fail:	Permission modification events are not collected	(PAGE 291)${ENDCOLOR}" 
		elif [[ $n = 10 ]]
		then
			echo 4.1.10 Ensure unsuccessful unauthorized file access attempts are collected
			echo -e "${RED}Fail:	unsuccessful unauthorised file access attempts are not collected	(PAGE 294)${ENDCOLOR}"
               	elif [[ $n = 11 ]]
		then
			echo 4.1.11 Ensure events that modify user/group information are collected
			echo -e "${RED}Fail:	events that modify user/group info are not collected	(PAGE 297)${ENDCOLOR}" 
		elif [[ $n = 12 ]]
		then
			echo 4.1.12 Ensure successful file system mounts are collected
			echo -e "${RED}Fail:	successful file system mouns are not collected	(PAGE 299)${ENDCOLOR}" 

		fi
               n=$(($n + 1))
failno=$(($failno + 1))
	elif [[ -z "$check1" ]] && [[ -n "$check2" ]]
        then
		if [[ $n = 9 ]]
                then
			echo  4.1.9 Ensure discretionary access control permission modification events are collected
			echo -e "${RED}Fail:	Permission modification events are not collected	(PAGE 291)${ENDCOLOR}" 
		elif [[ $n = 10 ]]
		then
			echo 4.1.10 Ensure unsuccessful unauthorized file access attempts are collected
			echo -e "${RED}Fail:	unsuccessful unauthorised file access attempts are not collected	(PAGE 294)${ENDCOLOR}"
               	elif [[ $n = 11 ]]
		then
			echo 4.1.11 Ensure events that modify user/group information are collected
			echo -e "${RED}Fail:	events that modify user/group info are not collected	(PAGE 297)${ENDCOLOR}" 
		elif [[ $n = 12 ]]
		then
			echo 4.1.12 Ensure successful file system mounts are collected
			echo -e "${RED}Fail:	successful file system mouns are not collected	(PAGE 299)${ENDCOLOR}" 

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
			echo -e "${RED}Fail:	File deletion events by users are not collected	(PAGE 303)${ENDCOLOR}"
		elif [[ $n = 15 ]]
		then
			echo 4.1.15 Ensure kernel module loading and unloading is collected
			echo -e "${RED}Fail:	insmod, rmmod and modprobe are not set	(PAGE 305)${ENDCOLOR}"
               
		fi
                n=$(($n + 1))
		failno=$(($failno + 1))
        elif [[ -n "$check1" ]] && [[ -z "$check2" ]]
        then

                if [[ $n = 14 ]]
                then
			echo '4.1.14 Ensure file detection events by users are collected'
			echo -e "${RED}Fail:	File deletion events by users are not collected	(PAGE 303)${ENDCOLOR}"

		elif [[ $n = 15 ]]
                then
                        echo 4.1.15 Ensure kernel module loading and unloading is collected
			echo -e "${RED}Fail:     insmod, rmmod and modprobe are not set	(PAGE 305)${ENDCOLOR}"

	 
		fi
                n=$(($n + 1))
failno=$(($failno + 1))
	elif [[ -z "$check1" ]] && [[ -n "$check2" ]]
        then

                if [[ $n = 14 ]]
                then
                        
			echo '4.1.14 Ensure file detection events by users are collected'
			echo -e "${RED}Fail:	File deletion events by users are not collected	(PAGE 303)${ENDCOLOR}"


                elif [[ $n = 15 ]]
                then
                        echo 4.1.15 Ensure kernel module loading and unloading is collected
			echo -e "${RED}Fail:     insmod, rmmod and modprobe are not set	(PAGE 305)${ENDCOLOR}"


		fi
                n=$(($n + 1))
failno=$(($failno + 1))

         else
		if [[ $n = 14 ]]
                then
                        
			echo '4.1.14 Ensure file detection events by users are collected'
			echo -e "${GREEN}Pass:	File deletion events by users are not collected${ENDCOLOR}"


                elif [[ $n = 15 ]]
                then
                        echo 4.1.15 Ensure kernel module loading and unloading is collected
			echo -e "${GREEN}Pass:     insmod, rmmod and modprobe are set${ENDCOLOR}"


		fi
		echo $n > /dev/null
		n=$(($n + 1))
passno=$(($passno + 1))

	fi
done

echo "4.1.16 Ensure system administrator actions (sudolog) are collected"
correctoutput=$(echo "-w $(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//') -p wa -k actions")

check1=$(grep -E "^\s*-w\s+$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//')\s+-p\s+wa\s+-k\s+actions" /etc/audit/rules.d/*.rules)

check2=$(auditctl -l | grep actions)

if [[ $check1 = "$correctoutput" ]] && [[ $check2 = "$correctoutput" ]]
then
        echo -e "${GREEN}Pass:	sudolog is collected${ENDCOLOR}"
passno=$(($passno + 1))
else
	echo -e "${RED}Fail:	sudolog is not collected	(PAGE 307)${ENDCOLOR}"
failno=$(($failno + 1))

fi


echo 4.1.17 Ensure the audit configuration is immutable
if [[ -z $(grep "^\s*[^#]" /etc/audit/rules.d/*.rules | grep -- "-e 2") ]]
then
	echo -e "${RED}Fail:	Audit configuration is not immutable	(PAGE 309)${ENDCOLOR}"  #Edit or create the file /etc/audit/rules.d/99-finalize.rulesand add the line "-e 2"
failno=$(($failno + 1))
else
	echo -e "${GREEN}Pass:	Audit configuration is immutable${ENDCOLOR}"
passno=$(($passno + 1))

fi
#-----------------------------------------------
#CHAP 6 Server lvl 2

echo 6.1.1 Audit system permissions

bashcheck=$(rpm -qf /bin/bash)
if [[ $bashcheck != 'bash-4.1.2-29.el6.x86_64 is not isntalled' ]]
then
	echo -e "${RED}Fail:	bash-4.1.2-29.el6.x86_64 is installed 	(PAGE 418) ${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	bash-4.1.2-29.el6.x86_64 is not installed${ENDCOLOR}"
	passno=$(($passno + 1))
fi

echo
echo NUMBER OF PASSES: $passno
echo NUMBER OF FAILED: $failno
}


sleep 2
echo -ne '##########                    [40% COMPLETE]\r'

level2s | tr '\t' ',' | tr -d '[' | sed -e 's/91m//g' | sed -e 's/92m//g' | sed -e 's/0m//g' >> all_audits.csv
level2s | tr '\t' ',' | tr -d '[' | sed -e 's/91m//g' | sed -e 's/92m//g' | sed -e 's/0m//g' > latestresult.csv
sleep 2

echo -ne '###############               [60% COMPLETE]\r'

level2s > latestresult.txt

sleep 2
cat latestresult.txt | tr '\t' ' '
echo -ne '####################  [80% COMPLETE]\r'
echo To view all previous audits in csv format, use command 'cat all_audits.csv'
echo 'To view latest audit in table format, install Libreoffice and: file > open 'latestresult.csv''
echo -ne '#########################[100% COMPLETE]\r'
echo -ne '\n'


fi


python3 graphoutput.py
