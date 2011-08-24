#!/usr/bin/perl -w
use strict;
use warnings;

package Domains;

# Expresiones regulares
# Dominios de internet
# http://en.wikipedia.org/wiki/List_of_Internet_top-level_domains
# Top Level Domain	
our $tld = '(a(ero|rpa|sia)|biz|c(at|om|oop)|edu|gov|i(nfo|nt)|jobs|m(il|obi|useum)|n(a(me|to)|et)|org|pro|t(el|ravel))';
# Country Code Top Level Domain	
our $cctld = '((a(c|d|e|f|g|i|l|m|n|o|q|r|s|t|u|w|x|z))|(b(a|b|d|e|f|g|h|i|j|m|n|o|r|s|t|v|w|y|z))|(c(a|c|d|f|g|h|i|k|l|m|n|o|r|s|u|v|x|y|z))|(d(d|e|j|k|m|o|z))|(e(c|e|g|h|r|s|t|u))|(f(i|j|k|m|o|r))|(g(a|b|d|e|f|g|h|i|l|m|n|p|q|r|s|t|u|w|y))|(h(k|m|n|r|t|u))|(i(d|e|l|m|n|o|q|r|s|t))|(j(e|m|o|p))|(k(e|g|h|i|m|n|p|r|w|y|z))|(l(a|b|c|i|k|r|s|t|u|v|y))|(m(a|c|d|e|g|h|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z))|(n(a|c|e|f|g|i|l|o|p|r|u|z))|(o(m))|(p(a|e|f|g|h|k|l|m|n|r|s|t|w|y))|(q(a))|(r(e|o|s|u|w))|(s(a|b|c|d|e|g|h|i|j|k|l|m|n|o|r|t|u|v|y|z))|(t(c|d|f|g|h|j|k|l|m|n|o|p|r|t|v|w|z))|(u(a|g|k|s|y|z))|(v(a|c|e|g|i|n|u))|(w(f|s))|(y(e|t))|(z(a|m|w)))';
# Dominio de internet
our $domain_regex = '[\w\d]+(\.?[\w\d\-])*\.'.$tld.'(\.'.$cctld.')?';
# Direccion IP
our $ip_regex = '(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})';
# Direccion ip entre parentesis y corchetes
our $enclosed_ip_regex = '\(\[($ip_regex)\]\)';

my $keep = 0;

my %addresses = ();
my %domains = ();

# Procesamiento multilinea
while(<STDIN>)
{
	chomp;
	# Procesa todas las lineas received
	if ( $_ =~ /^Received:\ (.*)$/ )
	{
		$keep = 1;
	}
	else
	{
		# Sigue procesando la siguiente linea si esta identada con espacios o tabuladores
		if ($keep && $_ =~ /^\s+\w(.*)$/ )
		{
			$keep = 1;
		}
		# Si no esta identada la siguiente linea no la proceses
		else
		{
			$keep = 0;
		}
	}
	# Imprime la linea si va a ser procesada
	#print $_."\n" if ($keep);
	$addresses{$1}++ if ($_ =~ /\(\[($ip_regex)\]\)/);
	$domains{$1}++ if ($_ =~ /($domain_regex)/);
}

foreach my $key (keys %domains)
{
	print STDERR $key."\t".$domains{$key}."\n";
}

foreach my $key (keys %addresses)
{
	print $key."\t".$addresses{$key}."\n";
}

exit;

use Net::Nslookup;
my @resolved = ();
foreach my $key (keys %domains)
{
	#push(@resolved,nslookup(type => "MX", domain => $key));
	push(@resolved,nslookup($key));
	print $key."\t".$domains{$key}."\n";
}
foreach my $key (@resolved)
{
	print $resolved[$key]."\n";
}
