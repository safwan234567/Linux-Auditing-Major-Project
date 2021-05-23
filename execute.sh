#! /bin/bash

cat banner

echo -ne '#####				[20% COMPLETE]\r'

combined() {
echo
echo -----------------------------
date
echo -----------------------------

#echo PART 1 INITIAL SETUP
#./InitialSetup

echo 
echo ----------------
echo PART 2 SERVICES
echo ----------------
./services.sh

echo
echo ---------------
echo PART 3 NETWORK
echo ---------------
./network.sh

echo 
echo ----------------------------
echo PART 4 LOGGING AND AUDITING
echo ----------------------------
./logandaudit.sh

echo
echo --------------------------
echo PART 6 SYSTEM MAINTANENCE
echo --------------------------
./SystemMaintenance.sh
echo
}
sleep 2
echo -ne '##########			[40% COMPLETE]\r'

combined | tr '\t' ',' >> all_audits.csv
sleep 2

echo -ne '###############		[60% COMPLETE]\r'
combined | tr '\t' ',' > latestresult.csv
sleep 2
cat latestresult.csv| tr ',' ' '
echo -ne '####################	[80% COMPLETE]\r'
echo To view all previous audits in csv format, use command 'cat all_audits.csv'

echo -ne '#########################[100% COMPLETE]\r'
echo -ne '\n'


