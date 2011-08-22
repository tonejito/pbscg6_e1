#!/usr/bin/perl -w
use strict;
use warnings;

package PackageConfigExporter;

=Begin NaturalDocs
	Package: PackageConfigExporter
	Description: Las variables exportadas se llaman como variables locales del script
=cut
use strict;
use warnings;

# Se utiliza exporter para exportar las variables definidas en el arreglo EXPORT
require Exporter;  
our @ISA = qw(Exporter);  
our @EXPORT=qw($logfile $outfile $domain_bl $pattern_bl $ip_bl $out_url $out_bindir $usrfile);
  
our $logfile	= "LOGfile";
our $outfile	= "OUTfile";
our $domain_bl	= "domain_BL";
our $pattern_bl	= "pattern_BL";
our $ip_bl	= "ip_BL";
our $out_url	= "OUT_url";
our $out_bindir	= "OUT_bindir";
our $usrfile	= "USRfile";

# = ^ . ^ =
1;
