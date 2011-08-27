#!/usr/bin/perl -w

#Proyecto Programacion en Perl

use strict;
use Net::Abuse::Utils qw( :all );

package archivos;
	our $file;
	our $blackfile;
	our $FILE;
	our $BLACKFILE;

package patrones;
	our %ip;
	our $tot_ip = 0;
	our %lista;
	our $tot_lista = 0;
        

#Función para determinar el número de argumentos
sub cuentaArgumentos{
	if(@ARGV < 2 ){
		print "USO: $0 --file=FILE --blacklist=FILE\n";
		exit;
	}
}

#Función para obtener y verificar el archivo a buscar y el archivo de lista negra
sub obtenArchivos{
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


sub imprimeResultados{
my $tope = 20;
my $k = 0;
	if($patrones::tot_ip != 0){
	print " ____________________________________________________________________________\n";
	print "\|	TOP	20     DIRECCIONES   IP     FUENTE    DE     SPAM           \|\n";
	print "\|___________________________________________________________________________\|\n";
	print "\|	Direccion IP			|		Incidencias         \|\n";
	print "\|_______________________________________|___________________________________\|\n";

		foreach  (reverse sort {$patrones::ip{$a} <=> $patrones::ip{$b}} keys %patrones::ip){
			if($k <= $tope){
				print "|		$	_		|     			$patrones::ip{$_}  	    |";
				print "\n";
			}
			$k++;
		}
	print "\|_______________________________________|___________________________________\|\n";
	}
	print "\n";
	$k = 0;
	if($patrones::tot_ip !=0){
	print " _______________________________________________________________________________________________________________\n";
	print "\|		                  		IP's Identificadas en Listas Negras			       \|\n";
	print "\|_____________________________________________________________________________________________________________ \|\n";
	print "\|	Direccion IP			|		Incidencias         |		Black List	       \|\n";
	print "\|_______________________________________|___________________________________|__________________________________\|\n";
				
		foreach  (reverse sort {$patrones::ip{$a} <=> $patrones::ip{$b}} keys %patrones::ip){
                        if($k <= $tope){
                        print "|                $       _               |                       $patrones::ip{$_}           |";
                                print "\n";
                        }
                        $k++;
                }
	print "\|_______________________________________|___________________________________|__________________________________\|\n";

	}

}

#Función para evaluar las opciones ingresadas
sub ejecutaOpciones{
	if(@ARGV == 2){
		open($archivos::FILE,"$archivos::file") || die "ERROR al abrir el archivo $archivos::file";
		$componentes::lineas=0;
		while(<$archivos::FILE>){
			chomp($_);
			ip($_);
			$componentes::lineas++;
		}
		imprimeResultados();
	#	listaNegra();
        	close($archivos::FILE);
	}
	else{
        	for(my $i=2;$i<@ARGV;$i++){
	                if($ARGV[$i] eq "--ip"){
				open($archivos::FILE,"$archivos::file") || die "ERROR al abrir el archivo $archivos::file";
				$componentes::lineas=0;
				while(<$archivos::FILE>){
					chomp($_);
					ip($_);
					$componentes::lineas++;
				}
        			close($archivos::FILE);
	                }#Fin ip
			else{
				print "Opción $ARGV[$i] no válida\n";
			}
        	}#Fin for
		close($archivos::FILE);
	}#Fin else
}


####### INICIO DEL PROGRAMA PRINCIPAL #######
cuentaArgumentos(); #Verificación de argumentos

obtenArchivos(); #Se obtienen los archivos

ejecutaOpciones(); #Se ejecutan las opciones que se le pasen al programa


#Función para detectar IP's
sub ip{
        my $linea0 = shift;
        if($linea0 =~ /((\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3}))/) {
                $patrones::ip{$1}++;
                $patrones::tot_ip++;
        }
}

#Función para comparar con la lista negra
sub comparaBlackList{
	open($archivos::BLACKFILE,"$archivos::blackfile") || die "ERROR al abrir el archivo $archivos::blackfile";
       my  $elemento = shift;
        while(<$archivos::BLACKFILE>){
                chomp($_);
                if($elemento =~ m/$_/){
                        print "--> LISTA NEGRA";
			last;
			#$hash++
                }
        }
	close($archivos::BLACKFILE);
}

