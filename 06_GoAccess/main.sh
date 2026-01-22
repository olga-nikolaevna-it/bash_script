#Var1 https://github.com/dorthava/DO4_LinuxMonitoring_v2.0/blob/main/src/06/main.sh
#!/bin/bash

if [ $# != 0 ]; then
echo -e "\e[91mError. The script must be run with 0 parameters.\e[0m"
exit 1
fi

rm -rf index.html
touch index.html
goaccess ../04/*.log --log-format=COMBINED > index.html

#Var2 и посмотри там html
#https://gitlab.com/school-215130028/devops-d04-linuxmonitoring-v2.0/-/blob/main/src/06/main.sh?ref_type=heads
#!/bin/bash

goaccess ../04/*.log --log-format=COMBINED > index.html


#My Var