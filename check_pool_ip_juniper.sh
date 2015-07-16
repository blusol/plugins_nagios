#!/bin/bash
address=$1
porc_w=$2
porc_c=$3
community=$4
id_pool=$5


#Comando recebe o snmpwak que coleta a porcentagem atual de uso.
porc_atual=`snmpwalk -m /usr/share/snmp/mibs/mib-jnx-user-aaa.txt -c $community -v 2c $address  JUNIPER-USER-AAA-MIB:jnxUserAAAAccessPoolAddressUsage | grep $5 | awk '{print $4}'`
uso_atual=`snmpwalk -m /usr/share/snmp/mibs/mib-jnx-user-aaa.txt -c $community -v 2c $address  JUNIPER-USER-AAA-MIB:jnxUserAAAAccessPoolAddressesInUse | awk '{print $4}' | paste -s -d + | bc`
pool=`snmpwalk -m /usr/share/snmp/mibs/mib-jnx-user-aaa.txt -c $community -v 2c $address  JUNIPER-USER-AAA-MIB:jnxUserAAAAccessPoolAddressTotal | egrep -v 16384 | egrep -v 65535 | awk '{print $4}' | paste -s -d + | bc`


###############
# Comparações

#Se uso do pool atual for menor que o quantidade de warning = ok

if [ "$porc_atual" -le "$porc_w" ];then
        echo "Pool Junos OK, Usado="$uso_atual" ips" $porc_atual"% | ips_usage=$uso_atual porcentagem=$porc_atual%;$porc_w;$porc_c"
        exit 0;
#Se uso do pool atual for maior que a quantidade de warring e menos q critical = warring
elif [ "$porc_atual" -gt "$porc_w" ] && [ "$porc_atual" -lt "$porc_c" ];then
        echo "Pool Junos Warning, Usado="$uso_atual" ips," $porc_atual"% | ips_usage=$uso_atual porcentagem=$porc_atual%;$porc_w;$porc_c"
        exit 1;
#Se o uso do pool atual for maior ou igual a quantidade de critical = critial
elif [ "$porc_atual" -gt "$porc_c" ] ||  [ "$porc_atual" == "$porc_c" ];then
        echo "Pool Junos Critical, Usado="$uso_atual" ips," $porc_atual"% | ips_usage=$uso_atual porcentagel=$porc_atual%;$porc_w;$porc_c"
        exit 2;
else
        echo "Problema na coleta dos dados"
        exit 3;

fi
