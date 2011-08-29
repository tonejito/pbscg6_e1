#!/usr/bin/perl -w

#Proyecto Programacion en Perl

use strict;

package patrones;
our $lineas = 0;
our $file;
our $blackfile;
our $FILE;
our $BLACKFILE;
our $ipregexp = '/((\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3}))/';
our %ip;
our $tot_ip = 0;
our $tot_lista = 0;
our %blacklist;
our $blacklist_message = "\t OK\n";

####### INICIO DEL PROGRAMA PRINCIPAL #######
cuentaArgumentos(); #Verificación de argumentos

obtenArchivos(); #Se obtienen los archivos

ejecutaOpciones(); #Se ejecutan las opciones que se le pasen al programa

#Función para determinar el número de argumentos
sub cuentaArgumentos
{
	if(@ARGV < 2 )
	{
		print "USO: $0 --file=FILE --blacklist=FILE\n";
		exit;
	}
}

#Función para obtener y verificar el archivo a buscar y el archivo de lista negra
sub obtenArchivos
{
	if($ARGV[0] =~ m/((--file=).*)/)
	{
		$file=$' if $ARGV[0] =~ m/=/;
	}
	else
	{
		print "USO: $0 --file=FILE --blacklist=FILE\n";
		exit;
	}
	if($ARGV[1] =~ m/((--blacklist=).*)/)
	{
		$blackfile=$' if $ARGV[1] =~ m/=/;
	}
	else
	{
		print "USO: $0 --file=FILE --blacklist=FILE \n";
		exit;
	}

	if(-e $file)
	{
		if(-f $file)
		{
			print "File: $file\n";
		}
		else
		{
			print "El archivo '$file' no es un archivo regular\n";
			exit;
		}
	}
	else
	{
		print "No se pudo encontrar el archivo '$file'\n";
		exit;
	}

	if(-e $blackfile)
	{
		if(-f $blackfile)
		{
			print "Blacklist File: $blackfile\n";
		}
		else
		{
			print "El archivo '$blackfile' no es un archivo regular\n";
			exit;
		}
	}
	else
	{
		print "No se pudo encontrar el archivo '$blackfile'\n";
		exit;
	}

}

#Función para evaluar las opciones ingresadas
sub ejecutaOpciones
{
	if(@ARGV == 2)
	{
		open($FILE,"$file") || die "ERROR al abrir el archivo $file";
		$lineas=0;
		while(<$FILE>)
		{
			chomp($_);
			ip($_);
			$lineas++;
		}
		imprimeResultados($_);
		construyeListaNegra();
        	close($FILE);
	}
	else
	{
        	for(my $i=2;$i<@ARGV;$i++)
        	{
	                if($ARGV[$i] eq "--ip")
	                {
				open($FILE,"$file") || die "ERROR al abrir el archivo $file";
				$lineas=0;
				while(<$FILE>){
					chomp($_);
					ip($_);
					$lineas++;
				}
        			close($FILE);
	                }#Fin ip
			else
			{
				print "Opción $ARGV[$i] no válida\n";
			}
        	}#Fin for
		close($FILE);
	}#Fin else
}

sub imprimeResultados
{
	my $tope = 20;
	my $k = 0;
	if($tot_ip != 0)
	{
	print " ____________________________________________________________________________\n";
	print "\|	TOP	20     DIRECCIONES   IP     FUENTE    DE     SPAM           \|\n";
	print "\|___________________________________________________________________________\|\n";
	print "\|	Direccion IP			|		Incidencias         \|\n";
	print "\|_______________________________________|___________________________________\|\n";

		foreach  (reverse sort {$ip{$a} <=> $ip{$b}} keys %patrones::ip)
		{
			if($k <= $tope)
			{
				print "|		$	_		|     			$ip{$_}  	   |";
				print "\n";
			}
			$k++;
		}
	print "\|_______________________________________|___________________________________\|\n";
	}
	print "\n";
	$k = 0;
	if($tot_ip !=0)
	{
	print " _______________________________________________________________________________________________________________\n";
	print "\|		                  		IP's Identificadas en Listas Negras			       \|\n";
	print "\|_____________________________________________________________________________________________________________ \|\n";
	print "\|	Direccion IP			|		Incidencias         |	     Black List y C&C	       \|\n";
	print "\|_______________________________________|___________________________________|__________________________________\|\n";
				
		foreach  (reverse sort {$ip{$a} <=> $ip{$b}} keys %patrones::ip)
		{
                        if($k <= $tope )
                        {
				 print "|                $       _              |       $ip{$_}           |		  		|";
                                print "\n"; 
                        }
                        $k++;
                }
	print "\|_______________________________________|___________________________________|__________________________________\|\n";
	}

}

#construye la lista negra
sub construyeListaNegra
{
	open(BLACKFILE, "$blackfile") || die ("No se pudo abrir el archivo:",$blackfile);
	while(<BLACKFILE>)
	{
		chomp();
		if($_ =~ /((\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3}))/)
		{
			$blacklist{$_}++;
		}
	}
}

#Función para detectar IP's
sub ip
{
        my $linea0 = shift;
        if($linea0 =~ /((\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3}))/)
        {
                $ip{$1}++;
                $tot_ip++;
        }
}

#checa si está en lista negra
sub isBlacklisted
{
	my $item = shift;	
	foreach my $element (keys %blacklist)
	{
		return $item if ($item eq $element);
	}
}

