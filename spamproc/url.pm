#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc::url;

our $conf;
our $verbose;

use spamproc::config;
use spamproc::log;
use spamproc::regex;

# Se utiliza exporter para exportar las variables definidas en el arreglo EXPORT
require Exporter;  
our @ISA = qw(Exporter);  
our @EXPORT=qw();



# = ^ . ^ =
1;

=Begin NaturalDocs
	Package: spamproc::url
	Description: 
=cut
