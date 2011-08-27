#!/usr/bin/perl -w
use strict;
use warnings;

package PackageConfig;

=Begin NaturalDocs
	Package: PackageConfig
	Description: Las variables aqui contenidas se llamaran con el nombre del paquete
=cut
use strict;
use warnings;

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
