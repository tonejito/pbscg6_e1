#!/usr/bin/perl -w

use strict;

package vars;
	our $file;
	our $blackfile;
	our $FILE;
	our $BLACKFILE;

package patrones;
	our %url;
	our $tot_url = 0;
	our $i;
	our %data;
# Top Level Domain	
our $tld = '(a(ero|rpa|sia)|biz|c(at|om|oop)|edu|gov|i(nfo|nt)|jobs|m(il|obi|useum)|n(a(me|to)|et)|org|pro|t(el|ravel))';
# Country Code Top Level Domain	
our $cctld = '((a(c|d|e|f|g|i|l|m|n|o|q|r|s|t|u|w|x|z))|(b(a|b|d|e|f|g|h|i|j|m|n|o|r|s|t|v|w|y|z))|(c(a|c|d|f|g|h|i|k|l|m|n|o|r|s|u|v|x|y|z))|(d(d|e|j|k|m|o|z))|(e(c|e|g|h|r|s|t|u))|(f(i|j|k|m|o|r))|(g(a|b|d|e|f|g|h|i|l|m|n|p|q|r|s|t|u|w|y))|(h(k|m|n|r|t|u))|(i(d|e|l|m|n|o|q|r|s|t))|(j(e|m|o|p))|(k(e|g|h|i|m|n|p|r|w|y|z))|(l(a|b|c|i|k|r|s|t|u|v|y))|(m(a|c|d|e|g|h|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z))|(n(a|c|e|f|g|i|l|o|p|r|u|z))|(o(m))|(p(a|e|f|g|h|k|l|m|n|r|s|t|w|y))|(q(a))|(r(e|o|s|u|w))|(s(a|b|c|d|e|g|h|i|j|k|l|m|n|o|r|t|u|v|y|z))|(t(c|d|f|g|h|j|k|l|m|n|o|p|r|t|v|w|z))|(u(a|g|k|s|y|z))|(v(a|c|e|g|i|n|u))|(w(f|s))|(y(e|t))|(z(a|m|w)))';
# Dominio de internet
our $domain_regex = '[\w\d]+(\.?[\w\d\-])*\.'.$tld.'(\.'.$cctld.')?';
our $protocol_regex = '(f|ht)tps?://' ;
our $path_regex = '[\w\d\-\/\+_.,:=#%]+';
# URL de http, https o ftp
our $url_regex = $protocol_regex.'('.$domain_regex.')'.$path_regex;

#Función para determinar el número de argumentos
sub cuentaArgumentos(){
	if(@ARGV < 2 ){
		print "USO: $0 --file=FILE --blacklist=FILE\n";
		exit;
	}
}

#Función para obtener y verificar el archivo a buscar y el archivo de lista negra
sub obtenArchivos(){
	if($ARGV[0] =~ m/((--file=).*)/){
		$archivos::file=$' if $ARGV[0] =~ m/=/;
	}else{
		print "USO: $0 --file=FILE --blacklist=FILE\n";
		exit;
	}
	if($ARGV[1] =~ m/((--blacklist=).*)/){
		$archivos::blackfile=$' if $ARGV[1] =~ m/=/;
	}else{
		print "USO: $0 --file=FILE --blacklist=FILE \n";
		exit;
	}

	if(-e $archivos::file){
		if(-f $archivos::file){
			print "File: $archivos::file\n";
		}
		else{
			print "El archivo '$archivos::file' no es un archivo regular\n";
			exit;
		}
	}
	else{
		print "No se pudo encontrar el archivo '$archivos::file'\n";
		exit;
	}

	if(-e $archivos::blackfile){
		if(-f $archivos::blackfile){
			print "Blacklist File: $archivos::blackfile\n";
		}
		else{
			print "El archivo '$archivos::blackfile' no es un archivo regular\n";
			exit;
		}		
	}
	else{
		print "No se pudo encontrar el archivo '$archivos::blackfile'\n";
		exit;
	}

}

sub imprimeResultados(){
	if($patrones::tot_url != 0){
                print "\n************************\nURLS\n--------------\n";
                foreach my $elemento (sort keys%patrones::url){
                        print "$elemento -  $patrones::url{$elemento}        ";
                        comparaBlackList($elemento);
                        print "\n";
                }
                print "Se encontraron $tot_url URLs\n";
        }

}

sub ejecutaOpciones(){
	if(@ARGV == 2){
		open($archivos::FILE,"$archivos::file") || die "ERROR al abrir el archivo $archivos::file";
		$componentes::lineas=0;
		while(<$archivos::FILE>){
			chomp($_);
			url($_);
			$componentes::lineas++;
		}
		imprimeResultados();
        	close($archivos::FILE);
	}elsif($ARGV[$i] eq "--url"){
				open($archivos::FILE,"$archivos::file") || die "ERROR al abrir el archivo $archivos::file";
				$componentes::lineas=0;
				while(<$archivos::FILE>){
                                        chomp($_);
                                        url($_);
                                        $componentes::lineas++;
                                }
                                close($archivos::FILE);
	                		}#Fin url
			else{
				print "Opción $ARGV[$i] no válida\n";
			}
		
		close($archivos::FILE);
				}#Fin else



####### INICIO DEL PROGRAMA PRINCIPAL #######
cuentaArgumentos(); #Verificación de argumentos

obtenArchivos(); #Se obtienen los archivos

ejecutaOpciones(); #Se ejecutan las opciones que se le pasen al programa

####### FIN DEL PROGRAMA PRINCIPAL #######

sub url(){ #Función para detectar URL's
	my $linea2 = shift;
        if($linea2 =~ /$url_regex/){
                $patrones::url{$2}++;
                $patrones::tot_url++;
        }
}

#Función para comparar con la lista negra
sub comparaBlackList(){
	open($archivos::BLACKFILE,"$archivos::blackfile") || die "ERROR al abrir el archivo $archivos::blackfile";
        my $elemento = shift;
        while(<$archivos::BLACKFILE>){
                chomp($_);
                if($elemento =~ m/$_/){
                        print "--> LISTA NEGRA";
                }
        }
	close($archivos::BLACKFILE);
}

