#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc::config;

# Se utiliza exporter para exportar las variables definidas en el arreglo EXPORT
require Exporter;  
our @ISA = qw(Exporter);  
our @EXPORT=qw($verbose $top $input $INPUT $domain_bl $DOMAIN_BL %blacklist_domain $pattern_bl $PATTERN_BL %blacklist_pattern $ip_bl $IP_BL %blacklist_ip $logfile $LOGFILE $outfile $OUTFILE $out_url $OUT_URL $usrfile $USRFILE $out_bindir);

our $verbose	= 0;
our $top	= 20;
# Input
our $input	= "fileinfo.txt";
#our $input	= "procregex.log";
our $INPUT	= *INPUT;
our $domain_bl	= "blacklist.domain";
our $DOMAIN_BL	= *DOMAIN_BL;
our %blacklist_domain;
our $pattern_bl	= "blacklist.pattern";
our $PATTERN_BL	= *PATTERN_BL;
our %blacklist_pattern;
our $ip_bl	= "blacklist.ip";
our $IP_BL	= *IP_BL;
our %blacklist_ip;
# Output
our $logfile	= "/tmp/log";
our $LOGFILE	= *LOGFILE;
our $outfile	= "output";
our $OUTFILE	= *STDERR;
our $out_url	= "output.url";
our $OUT_URL	= *OUT_URL;
our $usrfile	= "output.user";
our $USRFILE	= *USRFILE;
# Output Directory
our $out_bindir	= "/tmp/dir/";

# = ^ . ^ =
1;

=Begin NaturalDocs
	Package: spamproc::config
	Description: Archivo de configuracion del programa.
=cut
