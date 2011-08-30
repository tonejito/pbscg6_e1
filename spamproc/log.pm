#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc::log;

our $conf;
our $verbose;

our $justify = 80;

use spamproc::config;

# Se utiliza exporter para exportar las variables definidas en el arreglo EXPORT
require Exporter;  
our @ISA = qw(Exporter);  
our @EXPORT=qw(logmsg separator);

########	########	########	########	########	
#	logmsg - 
sub logmsg
{
	local *LOG = shift;
	my $msg= shift;
	# Obtiene el nombre de la funcion que llamo esta subrutina
	my $currentFunction = (caller(1))[3];
	# Si no hay funcion, entonces se esta llamando desde main
	$currentFunction = 'main' if (!$currentFunction);
	(my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst)=localtime(time);
	printf LOG "[%02d-%02d-%04d %02d:%02d:%02d][$currentFunction] %s\n",$mon+1,$mday,$year+1900,$hour,$min,$sec,$msg if ($verbose);
}

########	########	########	########	########	
#	separator - imprime un separador de longitud variable
sub separator
{
	my $type = shift;
	chomp $type;
	printf "\n%-".$justify."s\n", $type;
	# Imprime el separador '-' el numero de veces necesarias para
	# justificar con espacios al tamaño del elemento más grande.
	print "-" x $justify; print "\n";	
}

# = ^ . ^ =
1;

=Begin NaturalDocs
	Package: spamproc::log
	Description: 
=cut
