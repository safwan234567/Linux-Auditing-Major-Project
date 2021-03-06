#! /bin/bash
#echo --------------------
#date
#echo --------------------
#echo
passno=0
failno=0

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"


echo 6.1 System File Permissions

echo 6.1.1 Audit system permissions

bashcheck=$(rpm -qf /bin/bash)
if [[ $bashcheck != 'bash-4.1.2-29.el6.x86_64 is not isntalled' ]]
then
	echo -e "${RED}Fail:	bash-4.1.2-29.el6.x86_64 is installed ${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	bash-4.1.2-29.el6.x86_64 is not installed 	(PAGE 418)${ENDCOLOR}"
	passno=$(($passno + 1))
fi

echo 6.1.2  Ensure permissions on /etc/passwd are configured

pcheck=$(stat --format="%A" /etc/passwd)
if [[ $pcheck != "-rw-r--r--" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 421)${ENDCOLOR}"
	passno=$(($passno + 1))
fi

echo 6.1.3  Ensure permissions on /etc/shadow are configured

pecheck=$(stat --format="%A" /etc/shadow)
if [[ $pecheck != "-rw-r-----" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 422)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.4  Ensure permissions on /etc/group are configured

percheck=$(stat --format="%A" /etc/group)
if [[ $percheck != "-rw-r--r--" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 423)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.5  Ensure permissions on /etc/gshadow are configured

permcheck=$(stat --format="%A" /etc/gshadow)
if [[ $permcheck != "-rw-r-----" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 424)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.6  Ensure permissions on /etc/passwd- are configured

permicheck=$(stat --format="%A" /etc/passwd-)
if [[ $permicheck != "-rw-------" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 425)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.7  Ensure permissions on /etc/shadow- are configured

permischeck=$(stat --format="%A" /etc/shadow-)
if [[ $permischeck != "-rw-------" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 426)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.8  Ensure permissions on /etc/group- are configured

permisscheck=$(stat --format="%A" /etc/group-)
if [[ $permisscheck != "-rw-------" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 428)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.9 Ensure permissions on /etc/gshadow- are configured

permissicheck=$(stat --format="%A" /etc/gshadow-)
if [[ $permissicheck != "-rw-r-----" ]]
then
	echo -e "${RED}Fail:	Permisions are not set${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	Permisions are set 	(PAGE 429)${ENDCOLOR}"
		passno=$(($passno + 1))

fi


echo 6.1.10 Ensure no world writable files exist

echeck=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002)
if [[ $echeck != "" ]]
then
	echo -e "${RED}Fail:	world writable files exist${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	No world writable files exist 	(PAGE 430)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.11 Ensure no unowned files or directories exist

encheck=$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser)
if [[ $encheck != "" ]]
then
	echo -e "${RED}Fail:	unowned files or directories exist${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	No unowned files or directories exist 	(PAGE 432)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.1.12 Ensure no ungrouped files or directories exist

enscheck=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nogroup)
if [[ $enscheck != "" ]]
then
	echo -e "${RED}Fail:	ungrouped files or directories exist${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	No ungrouped files or directories exist 	(PAGE 434)${ENDCOLOR}"
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
	echo -e "${GREEN}Pass:	password feilds are not empty 	(PAGE 441)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.2.2 Ensure no legacy "+" entries exist in /etc/passwd

lcheck=$(grep '^\+:' /etc/passwd)
if [[ $lcheck != "" ]]
then
	echo -e "${RED}Fail:	legacy "+" entries exist in /etc/passwd${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	no legacy "+" entries exist in /etc/passwd 	(PAGE 442)${ENDCOLOR}"
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
echo -e "${RED}Fail:	Cant ensure root PATH Integrity 	(PAGE 443)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.4 Ensure no legacy "+" entries exist in /etc/shadow

lecheck=$(grep '^\+:' /etc/shadow)
if [[ $lecheck != "" ]]
then
	echo -e "${RED}Fail:	legacy "+" entries exist in /etc/shadow${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	no legacy "+" entries exist in /etc/shadow 	(PAGE 444)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.2.5 Ensure no legacy "+" entries exist in /etc/group

legcheck=$(grep '^\+:' /etc/group)
if [[ $legcheck != "" ]]
then
	echo -e "${RED}Fail:	legacy "+" entries exist in /etc/group${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	no legacy "+" entries exist in /etc/group 	(PAGE 445)${ENDCOLOR}"
		passno=$(($passno + 1))

fi

echo 6.2.6 Ensure root is the only UID 0 account

rcheck=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)
if [[ $rcheck != "root" ]]
then
	echo -e "${RED}Fail:	root is the only UID 0 account${ENDCOLOR}" 
	failno=$(($failno + 1))
else 
	echo -e "${GREEN}Pass:	root is the only UID 0 account 	(PAGE 446)${ENDCOLOR}" 
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
echo -e "${RED}Fail:	users home directories permissions are NOT 750 or more restrictive 	(PAGE 447)${ENDCOLOR}"
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
echo -e "${RED}Fail:	users do not own their home directories 	(PAGE 449)${ENDCOLOR}"
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
echo -e "${RED}Fail:	users dot files are group or world writable 	(PAGE 451)${ENDCOLOR}"
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
echo -e "${RED}Fail:	users have .forward files 	(PAGE 453)${ENDCOLOR}"
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
echo -e "${RED}Fail:	Users have .netrc files 	(PAGE 455)${ENDCOLOR}"
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
echo -e "${RED}Fail:	users .netrc Files are group or world accessible 	(PAGE 457)${ENDCOLOR}"
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
echo -e "${RED}Fail:	users have .rhosts files 	(PAGE 460)${ENDCOLOR}"
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
echo -e "${RED}Fail:	all groups in /etc/passwd do not exist in /etc/group 	(PAGE 462)${ENDCOLOR}"
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
echo -e "${RED}Fail:	Duplicate UIDs exist 	(PAGE 463)${ENDCOLOR}"
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
echo -e "${RED}Fail:	duplicate GIDs exist 	(PAGE 464)${ENDCOLOR}"
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
echo -e "${RED}Fail:	duplicate user names exist 	(PAGE 465)${ENDCOLOR}"
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
echo -e "${RED}Fail:	duplicate group names exist 	(PAGE 466)${ENDCOLOR}"
failno=$(($failno + 1))
fi

echo 6.2.19 Ensure shadow group is empty

emptycheck=$(grep ^shadow:[^:]*:[^:]*:[^:]+ /etc/group | awk -F: '($4 == "<shadow-gid>") { print }' /etc/passwd)
if [[ -z "$emptycheck" ]]
then
 echo -e "${GREEN}Pass:	shadow group is empty${ENDCOLOR}"
 passno=$(($passno + 1))
else
echo -e "${RED}Fail:	shadow group is NOT empty 	(PAGE 467)${ENDCOLOR}"
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
echo -e "${RED}Fail:	Not all users home directories exist 	(PAGE 468)${ENDCOLOR}"
failno=$(($failno + 1))
fi



echo 'NUMBER OF PASSES:	'$passno''
echo 'NUMBER OF FAILED:	'$failno''

