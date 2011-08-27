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
our @EXPORT=qw($conf $logfile $outfile $domain_bl $pattern_bl $ip_bl $out_url $out_bindir $usrfile);

# Input
our $conf		= "INPUT";
our $logfile	= "INPUT";
our $domain_bl	= "INPUT";
our $pattern_bl	= "INPUT";
our $ip_bl		= "INPUT";
# Output
our $outfile	= "OUTPUT";
our $out_url	= "OUTPUT";
our $usrfile	= "OUTPUT";
# Output Directory
our $out_bindir	= "DIR";

# = ^ . ^ =
1;
