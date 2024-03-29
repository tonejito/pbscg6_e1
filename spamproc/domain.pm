#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc::domain;

our $conf;
our $verbose;

our $keep = 0;
our %domains = ();
our %resolved = ();

use Net::DNS::Nslookup;

use spamproc::config;
use spamproc::log;
use spamproc::regex;

use spamproc::ip;

# Se utiliza exporter para exportar las variables definidas en el arreglo EXPORT
require Exporter;  
our @ISA = qw(Exporter);  
our @EXPORT=qw($keep %addresses %domains %resolved processDomains resolveDomains printResolvedDomains);

########	########	########	########	########	
#	
sub processDomains
{
	logmsg($LOGFILE,"source domains");
	separator "source domains" if ($debug);
	foreach my $key (sort {$domains{$b} <=> $domains{$a}} keys %domains)
	{
		logmsg($LOGFILE,$key."\t".$domains{$key}) if ($verbose);
		print $key."\t".$domains{$key}."\n" if ($debug);
	}
}

########	########	########	########	########	
#	
sub resolveDomains
{
	logmsg($LOGFILE,"nslookup");
	separator "nslookup" if ($debug);
	foreach my $domain (sort {$domains{$b} <=> $domains{$a}} keys %domains)
	{
		my $response = Net::DNS::Nslookup->get_ips($domain);
		
		# Para cada linea de dominio , IP
		foreach (split(/\n/,$response))
		{
			# Separa dominio e ip
			my @x = split(/,/,$_);
			# El dominio se descarta de cada linea
			my $dom = $x[0];
			logmsg($LOGFILE,$dom."\t\t".$x[1]) if ($verbose);
			print $dom."\n\t".$x[1]."\n" if ($debug);
			
			# Agrega la IP resuelta a la lista
			$resolved{$dom}.=$x[1]." ";
			# Agrega la IP resuelta al hash de direcciones
			$addresses{$x[1]}++;
		}
	}
}

########	########	########	########	########	
#	
sub printResolvedDomains
{
	foreach my $domain (keys %resolved)
	{
		print $domain."\n" if ($debug);
		foreach my $address ($resolved{$domain})
		{
			logmsg($LOGFILE,$address) if ($verbose);
			print "\t".$address."\n" if ($debug);
		}
	}
}

# = ^ . ^ =
1;

=Begin NaturalDocs
	Package: spamproc::domain
	Description: 
=cut
