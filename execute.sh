#! /bin/bash

cat banner
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


combined | tr '\t' ',' >> all_audits.csv
combined | tr '\t' ',' > latestresult.csv
cat latestresult.csv| tr ',' ' '
echo To view all previous audits in csv format, use command 'cat all_audits.csv'
