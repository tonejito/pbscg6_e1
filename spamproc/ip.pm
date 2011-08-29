#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc::ip;

our $conf;
our $verbose;

our %addresses = ();
our %blacklistedAddresses = ();

use spamproc::config;
use spamproc::log;
use spamproc::regex;

# Se utiliza exporter para exportar las variables definidas en el arreglo EXPORT
require Exporter;  
our @ISA = qw(Exporter);  
our @EXPORT=qw(%addresses %blacklistedAddresses isIP isBlacklistedIP backlistedSourceAddresses printSourceAddresses printBlacklistedAddresses);

########	########	########	########	########	
#	isIP - Verifica si la cadena es una direccion IP
sub isIP
{
	my $ip = shift;
	chomp $ip;
	if ($ip =~ /($ip_regex)/)
	{
		my $a = $2;
		my $b = $3;
		my $c = $4;
		my $d = $5;
		# IP dentro del rango 0.0.0.0 - 255.255.255.255
		if($a>=0 and $a <=255 and $b>=0 and $b <=255 and $c>=0 and $c <=255 and $d>=0 and $d <=255)
		{
			return $ip;
		}
	}
}

########	########	########	########	########	
#	
sub isBlacklistedIP
{
	my $addr = shift;
	# Itera en la lista negra
	foreach my $entry (keys %blacklist_ip)
	{
		# Agrega al hash de elementos en lista negra si se listo como malo.
		return $addr if ($addr eq $entry);
	}
	return 0;
}

########	########	########	########	########	
#	
sub backlistedSourceAddresses
{
	# Itera en todas las direcciones encontradas
	foreach my $addr (keys %addresses)
	{
		# Agrega al hash de elementos en lista negra si se listo como malo.
		$blacklistedAddresses{$addr} = $addresses{$addr} if ($addr and isBlacklistedIP($addr));
	}
}

########	########	########	########	########	
#	
sub printSourceAddresses
{
	logmsg($LOGFILE,"source addresses");
	separator "source addresses";
	foreach my $key (sort {$addresses{$b} <=> $addresses{$a}} keys %addresses)
	{
		logmsg($LOGFILE,$key."\t".$addresses{$key}) if ($verbose);
		print $key."\t".$addresses{$key}."\n";
	}
}

########	########	########	########	########	
#	
sub printBlacklistedAddresses
{
	logmsg($LOGFILE,"blacklisted addresses");
	separator "blacklisted addresses";
	foreach my $key (sort {$blacklistedAddresses{$a} <=> $blacklistedAddresses{$b}} keys %blacklistedAddresses)
	{
		logmsg($LOGFILE,$key."\t".$blacklistedAddresses{$key}) if ($verbose);
		print $key."\t".$blacklistedAddresses{$key}."\n";
	}
}

# = ^ . ^ =
1;

=Begin NaturalDocs
	Package: spamproc::ip
	Description: 
=cut
