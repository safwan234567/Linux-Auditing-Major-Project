
          


                 _ _ _     _   _     _             
                | (_) |   | | | |   (_)            
  __ _ _   _  __| |_| |_  | |_| |__  _ _ __   __ _ 
 / _` | | | |/ _` | | __| | __| '_ \| | '_ \ / _` |
| (_| | |_| | (_| | | |_  | |_| | | | | | | | (_| |
 \__,_|\__,_|\__,_|_|\__|  \__|_| |_|_|_| |_|\__, |
                                              __/ |
                                             |___/ 
                                
                                             
How to use Audit Thing

FOR FULL PACKAGE:
After downloading, go to the directory of AuditThing and use the following command:
`chmod u+x AuditThing`

Next, run the script with `./AuditThing`

Next, choose your machine configuration from the options and press enter
(What each configuration is for is explained in the official website)



FOR INDIVIDUAL SYSTEM CONFIGURATIONS:
After downloading, go to the directory of AuditThing and use the following command:
`chmod u+x <your_system_config>.sh`
For Level 1 server, replace <your_system_config> with level1server
For Level 2 server, replace <your_system_config> with level2server
For Level 1 workstation, replace <your_system_config> with level1workstation
For Level 2 workstation, replace <your_system_config> with level2workstation

Next, run the script with `./<your_system_config>.sh`



RESULTS:
Using LibreOffice Calc or any other application that allows you to open csv files, you can view the latest results
by going to file>open>latestresult.csv

You can also view all the results of all the audits conducted on your machine by opening all_audits.csv in LibreOffice Calc

For failed audits, the page number is shown so you can refer to the Linux CIS CentOS 8 Benchmark to remediate them.

