#!/usr/bin/perl -w
use strict;
use warnings;
use Net::DNS::Nslookup;

package Domains;

# Expresiones regulares
# Dominios de internet
# http://en.wikipedia.org/wiki/List_of_Internet_top-level_domains
# Top Level Domain	
our $tld = '(a(ero|rpa|sia)|biz|c(at|om|oop)|edu|gov|i(nfo|nt)|jobs|m(il|obi|useum)|n(a(me|to)|et)|org|pro|t(el|ravel))';
# Country Code Top Level Domain	
our $cctld = '((a(c|d|e|f|g|i|l|m|n|o|q|r|s|t|u|w|x|z))|(b(a|b|d|e|f|g|h|i|j|m|n|o|r|s|t|v|w|y|z))|(c(a|c|d|f|g|h|i|k|l|m|n|o|r|s|u|v|x|y|z))|(d(d|e|j|k|m|o|z))|(e(c|e|g|h|r|s|t|u))|(f(i|j|k|m|o|r))|(g(a|b|d|e|f|g|h|i|l|m|n|p|q|r|s|t|u|w|y))|(h(k|m|n|r|t|u))|(i(d|e|l|m|n|o|q|r|s|t))|(j(e|m|o|p))|(k(e|g|h|i|m|n|p|r|w|y|z))|(l(a|b|c|i|k|r|s|t|u|v|y))|(m(a|c|d|e|g|h|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z))|(n(a|c|e|f|g|i|l|o|p|r|u|z))|(o(m))|(p(a|e|f|g|h|k|l|m|n|r|s|t|w|y))|(q(a))|(r(e|o|s|u|w))|(s(a|b|c|d|e|g|h|i|j|k|l|m|n|o|r|t|u|v|y|z))|(t(c|d|f|g|h|j|k|l|m|n|o|p|r|t|v|w|z))|(u(a|g|k|s|y|z))|(v(a|c|e|g|i|n|u))|(w(f|s))|(y(e|t))|(z(a|m|w)))';
# Dominio de internet
our $domain_regex = '[\w\d]+(\.?[\w\d\-])*\.(('.$tld.'(\.'.$cctld.')?)|'.$cctld.')';

# Direccion IP
our $ip_regex = '(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})';
# Direccion ip entre parentesis y corchetes
our $enclosed_ip_regex = '\(\[($ip_regex)\]\)';
# Porcion del usuario en un correo electronico
our $user_regex = '[\w\d]+[\w\d\-_.]*';
# Direccion de correo electronico
our $mail_regex = '('.$user_regex.')@('.$domain_regex.')';
# Display name
our $displayName = '\".*\"';
# Display name codificado
our $encodedDisplayName = '\=\?[\w\d\-_.]+\?.*\?\=';


my $keep = 0;

my %addresses = ();
my %domains = ();
my %resolved = ();
my %recipients = ();
my %mails = ();

# Procesamiento multilinea
while(<STDIN>)
{
	chomp;
	# Procesa las lineas de destinatario
	$mails{$3}++ if ($_ =~ /^To:\ ($displayName|$encodedDisplayName)?(\s+)?\<?($mail_regex)\>?.*$/);
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
	# Agrega la linea al hash si contiene una direccion IP
	$addresses{$1}++ if ($_ =~ /\(\[($ip_regex)\]\)/);
	# Agrega la linea al hash si se marco para ser procesada y si contiene un dominio
	$domains{$1}++ if ($keep and $_ =~ /($domain_regex)/);
}

domain_processing();
address_processing();
mail_processing();
nslookup();

sub domain_processing
{
	print "\n\n\n"."--domains--"."\n";
	foreach my $key (sort {$domains{$b} <=> $domains{$a}} keys %domains)
	{
		print $key."\t".$domains{$key}."\n";
	}
}

sub nslookup
{
	print "\n\n\n"."--nslookup--"."\n";
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
			print $dom."\n\t".$x[1]."\n";
			
			# Agrega la IP resuelta a la lista
			$resolved{$dom}.=$x[1]." ";
			# Agrega la IP resuelta al hash de direcciones
			$addresses{$x[1]}++;
		}
	}
	
	foreach my $domain (keys %resolved)
	{
		print $domain."\n";
		foreach my $address ($resolved{$domain})
		{
			print "\t".$address."\n";
		}
	}
}

sub address_processing
{
	print "\n\n\n"."--addresses--"."\n";
	foreach my $key (sort {$addresses{$b} <=> $addresses{$a}} keys %addresses)
	{
		print $key."\t".$addresses{$key}."\n";
	}
}

sub mail_processing
{
	print "\n\n\n"."--email--"."\n";
	foreach my $m (sort {$mails{$b} <=> $mails{$a}} keys %mails)
	{
		print $m."\t".$mails{$m}."\n";
	}
}
