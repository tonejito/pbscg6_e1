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
print "\$PackageConfig::var\n";
print $PackageConfig::logfile."\n";
print $PackageConfig::outfile."\n";
print $PackageConfig::domain_bl."\n";
print $PackageConfig::pattern_bl."\n";
print $PackageConfig::ip_bl."\n";
print $PackageConfig::out_url."\n";
print $PackageConfig::out_bindir."\n";
print $PackageConfig::usrfile."\n";

print "\n";
use PackageConfigExporter;
# Si se habilito el uso de Exporter en el modulo de configuracion se pueden llamar las variables directamente
print "use PackageConfigExporter\n";
print $logfile."\n";
print $outfile."\n";
print $domain_bl."\n";
print $pattern_bl."\n";
print $ip_bl."\n";
print $out_url."\n";
print $out_bindir."\n";
print $usrfile."\n";

print "\n";

# Importando variables desde un archivo externo
require "config.pl";
# Las variables se pueden utilizar como si fueran locales
print "require config.pl\n";
print $logfile."\n";
print $outfile."\n";
print $domain_bl."\n";
print $pattern_bl."\n";
print $ip_bl."\n";
print $out_url."\n";
print $out_bindir."\n";
print $usrfile."\n";

# = ^ . ^ =
