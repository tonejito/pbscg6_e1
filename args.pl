#!/usr/bin/perl -w
use strict;
use warnings;

package TestConfig;

=Begin NaturalDocs
	Package: TestConfig
	Description: Utilizando las variables definidas de otros scripts utilizando 'use' y 'require'
=cut

# Importando variables desde un modulo externo
use PackageConfig;
# Se llama las variables con el nombre largo
#print "\$PackageConfig::var\n";
#print $PackageConfig::logfile."\n";
#print $PackageConfig::outfile."\n";
#print $PackageConfig::domain_bl."\n";
#print $PackageConfig::pattern_bl."\n";
#print $PackageConfig::ip_bl."\n";
#print $PackageConfig::out_url."\n";
#print $PackageConfig::out_bindir."\n";
#print $PackageConfig::usrfile."\n";

#print "\n";
use PackageConfigExporter;
# Si se habilito el uso de Exporter en el modulo de configuracion se pueden llamar las variables directamente
#print "use PackageConfigExporter\n";
#print $logfile."\n";
#print $outfile."\n";
#print $domain_bl."\n";
#print $pattern_bl."\n";
#print $ip_bl."\n";
#print $out_url."\n";
#print $out_bindir."\n";
#print $usrfile."\n";

#print "\n";

# Importando variables desde un archivo externo
require "config.pl";
# Las variables se pueden utilizar como si fueran locales
#print "require config.pl\n";
#print $logfile."\n";
#print $outfile."\n";
#print $domain_bl."\n";
#print $pattern_bl."\n";
#print $ip_bl."\n";
#print $out_url."\n";
#print $out_bindir."\n";
#print $usrfile."\n";

# Parseo de los argumentos de la linea de comandos
foreach my $arg (@ARGV)
{
	my $a = substr($arg,0,5+2);
	my $b = substr($arg,0,7+2);
	my $c = substr($arg,0,9+2);
	my $d = substr($arg,0,10+2);
	
	my $A = substr($arg,6+2);
	my $B = substr($arg,8+2);
	my $C = substr($arg,10+2);
	my $D = substr($arg,11+2);
	$logfile	= $B if ($B and $b eq '--logfile' );
	$outfile	= $B if ($B and $b eq '--outfile' );
	$domain_bl	= $C if ($C and $c eq '--domain_bl' );
	$pattern_bl	= $D if ($D and $d eq '--pattern_bl' );
	$ip_bl		= $A if ($A and $a eq '--ip_bl' );
	$out_url	= $B if ($B and $b eq '--out_url' );
	$out_bindir	= $D if ($D and $d eq '--out_bindir' );
	$usrfile	= $B if ($B and $b eq '--usrfile' );
}

print ">> after parsing\n";
print $logfile."\n";
print $outfile."\n";
print $domain_bl."\n";
print $pattern_bl."\n";
print $ip_bl."\n";
print $out_url."\n";
print $out_bindir."\n";
print $usrfile."\n";
print "\n";

# = ^ . ^ =
