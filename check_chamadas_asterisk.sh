#!/bin/bash
#Alan C. Besen (Unifique Telecom) - 10/08/2014 - alan.besen@redeunifique.com.br
#Versão 0.01 (Funcionou, mas não tinha testes para verificar se o warning era maior que o critical)
#Versao 0.02 (stable)
#Verifica a quantidade de canais usados no asterisk, com perf data e ainda não fiz um template para pnp4nagios (use o integer.php como base para um grágico padrão). 
#Testado em CentOS 5/6/7 e HREL 6
#Uso: ./check_asterisk_channels.sh [w] [c]

#Verifica a quantidade de canais alocados pelo asterisk (aqui provavelmente o usuário do nagios/nrpe precisará de config no /etc/sudoers)
canais=`sudo /usr/sbin/asterisk -rx "core show calls" | grep active\ call | cut -d" " -f1`

#Não estou colocando acentuação na saída da checagem, assim evita erros de charset/locale com o nagios. 
if [ $# == 0 ]; then
        echo "OK: $canais chamadas simultaneas |chamadas=$canais"
        exit 0
fi

#Cria o menu de ajuda
if [ "$1" == "-h" -o "$1" == "--help" ]; then
        echo "$0 [W] [C]"
        echo "W = warning"
        echo "C = critical"
        exit 3ccccccc
elif [ -z "$canais" ]; then
        echo "ERRO: Verifique a se todos os paths estão corretos e se o usuário do nagios/nrpe está com permissão correta"
        exit 3
fi

#Testa de o valor de warning é maior que critical (bug 01) 
if [ -n "$2" ];then
        if [ "$1" -gt "$2" ];then
                echo "ERRO: Warning está maior que o Critical :) - Veja a ajuda!"
                echo "$0 $1 $2"
                exit 2
       fi

        if [ "$canais" -ge $1 -a "$canais" :-lt $2 ];then
                echo "WARNING: $canais chamadas simultaneas|chamadas=$canais"
                exit 2
        fi

        if [ "$canais" -ge "$2" ];then
                echo "CRITICAL: $canais chamadas simultaneas|chamadas=$canais"
                exit 2
        fi
elif [ "$canais" -ge "$1" ];then
                echo "WARNING: $canais chamadas simultaneas|chamadas=$canais"
                exit 2
fi

if [ "$canais" -lt "$1" ];then
        echo "OK:$canais chamadas simultaneas|chamadas=$canais"
        exit 0
fi
