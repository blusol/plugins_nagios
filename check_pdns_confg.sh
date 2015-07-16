#!/bin/sh
#checa se todas as zonas no pdns estao ok e se nao tem erros em registros.

echo "" > /tmp/pdns_nagios.txt
pdnssec check-all-zones >> /tmp/pdns_nagios.txt
saida=`cat /tmp/pdns_nagios.txt | grep -v Checked`

if [[ -z $saida ]]; then

echo "OK: Sem erros nas zonas"
exit 0

else

erro=`cat /tmp/pdns_nagios.txt | grep had`
echo "CRITICAL: $erro - Log em: /var/log/pdns_nagios.txt "
exit 2

fi
