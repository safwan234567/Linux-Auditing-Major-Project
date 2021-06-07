#! /bin/bash



chmod u+x level1server.sh
chmod u+x level2server.sh
chmod u+x level1workstation.sh
chmod u+x level2workstation.sh

echo -------------
echo AUDIT THING
echo -------------
echo
echo -e "Hi, which system are you using? \n1) Level 1 Server \n2) Level 2 Server\n3) Level 1 Workstation\n4) Level 2 Workstation\n enter the number:"

read configtype

if [[ $configtype = '1' ]]
then
	./level1server.sh
elif [[ $configtype = '2' ]]
then
	./level2server.sh
elif [[ $configtype = '3' ]]
then
	./level1workstation.sh
elif [[ $configtype = '4' ]]
then
	./level2workstation.sh
else
	echo Type in a number between 1 and 4
fi

