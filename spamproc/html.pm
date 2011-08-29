#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc::html;

our $conf;
our $verbose;
our $html="<html><body>"."\n";

use spamproc::config;
use spamproc::log;
use spamproc::util;
use spamproc::regex;
use spamproc::domain;
use spamproc::subjects;
use spamproc::ip;
use spamproc::url;
use spamproc::email;
use spamproc::attachment;

# Se utiliza exporter para exportar las variables definidas en el arreglo EXPORT
require Exporter;  
our @ISA = qw(Exporter);  
our @EXPORT=qw($html one two three four five six);

sub one
{
	# 
	my $i = 1;
	$html.='<table border=1>'."\n";
	$html.='<caption>'.'Top '.$top.' Direcciones IP fuente de SPAM'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>IP</th><th>Incidencias</th></tr>'."\n";
	foreach my $addr (sort {$addresses{$b} <=> $addresses{$a}} keys %addresses)
	{
		$html.='<tr><td>'.$i.'</td><td>'.$addr.'</td><td>'.$addresses{$addr}.'</td></tr>'."\n";
		last if ($i == 20);
		$i++;
	}
	$html.='</table>'."\n";
	# 
	$i = 1;
	$html.='<table border=1>'."\n";
	$html.='<caption>'.'IP identificadas en lista negra'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>IP</th><th>Incidencias</th><th>Blacklist?</th></tr>'."\n";
	foreach my $addr (sort {$blacklistedAddresses{$a} <=> $blacklistedAddresses{$b}} keys %blacklistedAddresses)
	{
		$html.='<tr><td>'.$i.'</td><td>'.$addr.'</td><td>'.$blacklistedAddresses{$addr}.'</td><td>'.'OK'.'</td></tr>'."\n";
		last if ($i == 20);
		$i++;
	}
	$html.='</table>'."\n";
}

sub two
{
	# 
	my $i = 1;
	$html.='<table border=1>'."\n";
	$html.='<caption>'.'Top '.$top.' Direcciones IP fuente de SPAM'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>IP</th><th>Incidencias</th></tr>'."\n";
	foreach my $d (sort {$domains{$b} <=> $domains{$a}} keys %domains)
	{
		$html.='<tr><td>'.$i.'</td><td>'.$d.'</td><td>'.$domains{$d}.'</td></tr>'."\n";
		last if ($i == 20);
		$i++;
	}
	$html.='</table>'."\n";
}

sub three
{
	# 
	my $i = 1;
	$html.='<table border=1>'."\n";
	$html.='<caption>'.'Top '.$top.' Dominios mas atacados'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>IP</th><th>Incidencias</th></tr>'."\n";
	foreach my $d (sort {$dst_domains{$b} <=> $dst_domains{$a}} keys %dst_domains)
	{
		$html.='<tr><td>'.$i.'</td><td>'.$d.'</td><td>'.$dst_domains{$d}.'</td></tr>'."\n";
		last if ($i == 20);
		$i++;
	}
	$html.='</table>'."\n";
}

sub four
{
	# 
	my $i = 1;
	$html.='<table border=1>'."\n";
	$html.='<caption>'.'Top '.$top.' Subjects'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>Subject</th><th>Incidencias</th></tr>'."\n";
	foreach my $item (sort {$subjects{$b} <=> $subjects{$a}} keys %subjects)
	{
		$html.='<tr><td>'.$i.'</td><td>'.$item.'</td><td>'.$subjects{$item}.'</td></tr>'."\n";
		last if ($i == 20);
		$i++;
	}
	$html.='</table>'."\n";
	
	# 
	$i = 1;
	$html.='<table border=1>'."\n";
	$html.='<caption>'.'Subjects identificados en listas negras'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>Subject</th><th>Incidencias</th><th>Blacklist</th><th>Patron</th></tr>'."\n";
	foreach my $item (sort {$blacklistedSubjects{$b} <=> $blacklistedSubjects{$a}} keys %blacklistedSubjects)
	{
		$html.='<tr><td>'.$i.'</td><td>'.$item.'</td><td>'.$blacklistedSubjects{$item}.'</td><td>'.'OK'.'</td><td>'.comparaBlackList($item).'</td></tr>'."\n";
		last if ($i == 20);
		$i++;
	}
	$html.='</table>'."\n";
}

sub five
{
	# 
	my $i = 1;
	$html.='<table border=1>'."\n";
	$html.='<caption>'.'URL de lista negra'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>Dominio</th><th>Incidencias</th><th>Blacklist Dominio</th><th>Blacklist Patron</th><th></th></tr>'."\n";
	#foreach my $item (%hash)
	#{
	#	$html.='<tr><td>'.$i.'</td><td>'.$item.'</td><td>'."###".'</td><td>'."OK".'</td><td>'."OK".'</td><td>'."".'</td></tr>'."\n";
	#	last if ($i == 20);
	#	$i++;
	#}
	$html.='</table>'."\n";
}

sub six
{
	# 
	my $i = 1;
	$html.='<table border=1>'."\n";
	$html.='<caption>'.'Top '.$top.' Archivos'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>Archivo</th><th>Incidencias</th><th>Descargado</th><th>URL</th></tr>'."\n";
	#foreach my $item (%hash)
	#{
	#	$html.='<tr><td>'.$i.'</td><td>'.$item.'</td><td>'."###".'</td><td>'."OK".'</td><td>'."https://localhost:443/".'</td></tr>'."\n";
	#	last if ($i == 20);
	#	$i++;
	#}
	$html.='</table>'."\n";
}

sub seven
{
	
}

# = ^ . ^ =
1;

=Begin NaturalDocs
	Package: spamproc::html
	Description: 
=cut
