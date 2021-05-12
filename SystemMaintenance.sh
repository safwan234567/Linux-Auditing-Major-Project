#! /bin/bash


echo 6.1.2  Ensure permissions on /etc/passwd are configured

pcheck=$(stat --format="%A" /etc/passwd)
if [[ $pcheck != "-rw-r--r--" ]]
then
	echo "Fail: Permisions are not set" 
else 
	echo "Pass: Permisions are set"
fi

echo 6.1.3  Ensure permissions on /etc/shadow are configured

pecheck=$(stat --format="%A" /etc/shadow)
if [[ $pecheck != "-rw-r-----" ]]
then
	echo "Fail: Permisions are not set" 
else 
	echo "Pass: Permisions are set"
fi

echo 6.1.4  Ensure permissions on /etc/group are configured

percheck=$(stat --format="%A" /etc/group)
if [[ $percheck != "-rw-r--r--" ]]
then
	echo "Fail: Permisions are not set" 
else 
	echo "Pass: Permisions are set"
fi

echo 6.1.5  Ensure permissions on /etc/gshadow are configured

permcheck=$(stat --format="%A" /etc/gshadow)
if [[ $permcheck != "-rw-r-----" ]]
then
	echo "Fail: Permisions are not set" 
else 
	echo "Pass: Permisions are set"
fi

echo 6.1.6  Ensure permissions on /etc/passwd- are configured

permicheck=$(stat --format="%A" /etc/passwd-)
if [[ $permicheck != "-rw-------" ]]
then
	echo "Fail: Permisions are not set" 
else 
	echo "Pass: Permisions are set"
fi

echo 6.1.7  Ensure permissions on /etc/shadow- are configured

permischeck=$(stat --format="%A" /etc/shadow-)
if [[ $permischeck != "-rw-------" ]]
then
	echo "Fail: Permisions are not set" 
else 
	echo "Pass: Permisions are set"
fi

echo 6.1.8  Ensure permissions on /etc/group- are configured

permisscheck=$(stat --format="%A" /etc/group-)
if [[ $permisscheck != "-rw-------" ]]
then
	echo "Fail: Permisions are not set" 
else 
	echo "Pass: Permisions are set"
fi

echo 6.1.9 Ensure permissions on /etc/gshadow- are configured

permissicheck=$(stat --format="%A" /etc/gshadow-)
if [[ $permissicheck != "-rw-r-----" ]]
then
	echo "Fail: Permisions are not set" 
else 
	echo "Pass: Permisions are set"
fi

#! /bin/bash


echo 6.1.10 Ensure no world writable files exist

echeck=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002)
if [[ $echeck != "" ]]
then
	echo "Fail: world writable files exist" 
else 
	echo "Pass: No world writable files exist"
fi

echo 6.1.11 Ensure no unowned files or directories exist

encheck=$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser)
if [[ $encheck != "" ]]
then
	echo "Fail: unowned files or directories exist" 
else 
	echo "Pass: No unowned files or directories exist"
fi

echo 6.1.12 Ensure no ungrouped files or directories exist

enscheck=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nogroup)
if [[ $enscheck != "" ]]
then
	echo "Fail: ungrouped files or directories exist" 
else 
	echo "Pass: No ungrouped files or directories exist"
fi

echo 6.1.13 Audit SUID executables
echo Output listed:
df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -4000

echo 6.1.14 Audit SGID executables
echo Output listed:
df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -2000