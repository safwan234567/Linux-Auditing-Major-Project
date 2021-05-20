#! /bin/bash
#echo --------------------
#date
#echo --------------------
#echo
passno=0
failno=0

echo 6.1 System File Permissions

echo 6.1.1 Audit system permissions

bashcheck=$(rpm -qf /bin/bash)
if [[ $bashcheck != 'bash-4.1.2-29.el6.x86_64 is not isntalled' ]]
then
	echo Fail: $bashcheck is installed
fi

echo 6.1.2  Ensure permissions on /etc/passwd are configured

pcheck=$(stat --format="%A" /etc/passwd)
if [[ $pcheck != "-rw-r--r--" ]]
then
	echo "Fail: Permisions are not set" 
	failno=$(($failno + 1))
else 
	echo "Pass: Permisions are set"
	passno=$(($passno + 1))
fi

echo 6.1.3  Ensure permissions on /etc/shadow are configured

pecheck=$(stat --format="%A" /etc/shadow)
if [[ $pecheck != "-rw-r-----" ]]
then
	echo "Fail: Permisions are not set" 
	failno=$(($failno + 1))
else 
	echo "Pass: Permisions are set"
		passno=$(($passno + 1))

fi

echo 6.1.4  Ensure permissions on /etc/group are configured

percheck=$(stat --format="%A" /etc/group)
if [[ $percheck != "-rw-r--r--" ]]
then
	echo "Fail: Permisions are not set" 
	failno=$(($failno + 1))
else 
	echo "Pass: Permisions are set"
		passno=$(($passno + 1))

fi

echo 6.1.5  Ensure permissions on /etc/gshadow are configured

permcheck=$(stat --format="%A" /etc/gshadow)
if [[ $permcheck != "-rw-r-----" ]]
then
	echo "Fail: Permisions are not set" 
	failno=$(($failno + 1))
else 
	echo "Pass: Permisions are set"
		passno=$(($passno + 1))

fi

echo 6.1.6  Ensure permissions on /etc/passwd- are configured

permicheck=$(stat --format="%A" /etc/passwd-)
if [[ $permicheck != "-rw-------" ]]
then
	echo "Fail: Permisions are not set" 
	failno=$(($failno + 1))
else 
	echo "Pass: Permisions are set"
		passno=$(($passno + 1))

fi

echo 6.1.7  Ensure permissions on /etc/shadow- are configured

permischeck=$(stat --format="%A" /etc/shadow-)
if [[ $permischeck != "-rw-------" ]]
then
	echo "Fail: Permisions are not set" 
	failno=$(($failno + 1))
else 
	echo "Pass: Permisions are set"
		passno=$(($passno + 1))

fi

echo 6.1.8  Ensure permissions on /etc/group- are configured

permisscheck=$(stat --format="%A" /etc/group-)
if [[ $permisscheck != "-rw-------" ]]
then
	echo "Fail: Permisions are not set" 
	failno=$(($failno + 1))
else 
	echo "Pass: Permisions are set"
		passno=$(($passno + 1))

fi

echo 6.1.9 Ensure permissions on /etc/gshadow- are configured

permissicheck=$(stat --format="%A" /etc/gshadow-)
if [[ $permissicheck != "-rw-r-----" ]]
then
	echo "Fail: Permisions are not set" 
	failno=$(($failno + 1))
else 
	echo "Pass: Permisions are set"
		passno=$(($passno + 1))

fi


echo 6.1.10 Ensure no world writable files exist

echeck=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002)
if [[ $echeck != "" ]]
then
	echo "Fail: world writable files exist" 
	failno=$(($failno + 1))
else 
	echo "Pass: No world writable files exist"
		passno=$(($passno + 1))

fi

echo 6.1.11 Ensure no unowned files or directories exist

encheck=$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser)
if [[ $encheck != "" ]]
then
	echo "Fail: unowned files or directories exist" 
	failno=$(($failno + 1))
else 
	echo "Pass: No unowned files or directories exist"
		passno=$(($passno + 1))

fi

echo 6.1.12 Ensure no ungrouped files or directories exist

enscheck=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nogroup)
if [[ $enscheck != "" ]]
then
	echo "Fail: ungrouped files or directories exist" 
	failno=$(($failno + 1))
else 
	echo "Pass: No ungrouped files or directories exist"
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
	echo "Fail: password feilds are empty" 
	failno=$(($failno + 1))
else 
	echo "Pass: password feilds are not empty"
		passno=$(($passno + 1))

fi

echo 6.2.2 Ensure no legacy "+" entries exist in /etc/passwd

lcheck=$(grep '^\+:' /etc/passwd)
if [[ $lcheck != "" ]]
then
	echo "Fail: legacy "+" entries exist in /etc/passwd" 
	failno=$(($failno + 1))
else 
	echo "Pass: no legacy "+" entries exist in /etc/passwd"
		passno=$(($passno + 1))

fi

echo 6.2.4 Ensure no legacy "+" entries exist in /etc/shadow

lecheck=$(grep '^\+:' /etc/shadow)
if [[ $lecheck != "" ]]
then
	echo "Fail: legacy "+" entries exist in /etc/shadow" 
	failno=$(($failno + 1))
else 
	echo "Pass: no legacy "+" entries exist in /etc/shadow"
		passno=$(($passno + 1))

fi

echo 6.2.5 Ensure no legacy "+" entries exist in /etc/group

legcheck=$(grep '^\+:' /etc/group)
if [[ $legcheck != "" ]]
then
	echo "Fail: legacy "+" entries exist in /etc/group" 
	failno=$(($failno + 1))
else 
	echo "Pass: no legacy "+" entries exist in /etc/group"
		passno=$(($passno + 1))

fi

echo 6.2.6 Ensure root is the only UID 0 account

rcheck=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)
if [[ $rcheck != "root" ]]
then
	echo "Fail: root is the only UID 0 account" 
	failno=$(($failno + 1))
else 
	echo "Pass: root is the only UID 0 account" 
		passno=$(($passno + 1))

fi

echo 6.2.8 Ensure users own their home directories

grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read -r user dir; do
    if [ ! -d "$dir" ]; then
        echo "The home directory \"$dir\" of user $user does not exist."
    else
        owner=$(stat -L -c "%U" "$dir")
        if [ "$owner" != "$user" ]; then
            echo "The home directory \"$dir\" of user $user is owned by $owner."
        fi
		
    fi
	echo "If no files are output PASS"
done


echo 6.2.9 Ensure users dot files are not group or world writable
 
grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read -r user dir; do
    if [ ! -d "$dir" ]; then
        echo "The home directory \"$dir\" of user \"$user\" does not exist."
    else
        for file in "$dir"/.[A-Za-z0-9]*; do
            if [ ! -h "$file" ] && [ -f "$file" ]; then
                fileperm="$(ls -ld "$file" | cut -f1 -d" ")"
                if [ "$(echo "$fileperm" | cut -c6)"  != "-" ]; then
                    echo "Group Write permission set on file $file"
                fi
                if [ "$(echo "$fileperm" | cut -c9)"  != "-" ]; then
                    echo "Other Write permission set on file \"$file\""
                fi
            fi
        done
    fi
	echo "If no files are output PASS"
done

echo 'NUMBER OF PASSES:	'$passno''
echo 'NUMBER OF FAILED:	'$failno''
