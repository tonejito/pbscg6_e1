#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc::html;

our $conf;
our $verbose;
our $html;
our $style = 
"<style type='text/css'> 
  .left{text-align: left;}
  .center{text-align: center;}
  .container
  {
  margin-left: auto;
  margin-right: auto;
  width: 50em;
  }
  
caption
{
 border-width: 1px;
 border-style: solid;
 background-color: #c0c0c0;
}
table.gridtable
{
 border-width: 1px;
 border-collapse: collapse;
}
table.gridtable th
{
 text-align: center;
 border-width: 1px;
 padding: 8px;
 border-style: solid;
 background-color: #000000;
 color: #ffffff;
}
table.gridtable td
{
 border-width: 1px;
 padding: 8px;
 border-style: solid;
}
</style>";

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
our @EXPORT=qw($html report one two three four five six);

sub report
{
	$html.="<html>"."\n";
	$html.="<head>"."\n";
	$html.="<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>"."\n";
	$html.="<title>Proyecto Perl - Plan de Becarios de Seguridad en Cómputo</title>"."\n";
	$html.=$style."\n";
	$html.="</head>"."\n";
	$html.="<body>"."\n";
	$html.="<table  class='gridtable'>"."\n";
	$html.="<caption></caption>"."\n";
	$html.='<tr><th>Integrantes</th></tr>'."\n";
	$html.='<tr><td>Andrés Leonardo Hernández Bermúdez</td></tr>'."\n";
	$html.='<tr><td>Miguel Raúl Bautista Soria</th></td>'."\n";
	$html.='<tr><td>RicardoGonzález del Castillo</th></td>'."\n";
	$html.="</table>"."\n";
	$html.="<br/>"."\n";
	one();
	two();
	three();
	four();
	five();
	six();
	seven();
	$html.="</body>"."\n";
	$html.="</html>"."\n";
}

sub one
{
	# 
	my $i = 1;
	$html.='<table class="gridtable">'."\n";
	$html.='<caption>'.'Top '.$top.' Direcciones IP fuente de SPAM'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>IP</th><th>Incidencias</th></tr>'."\n";
	foreach my $addr (sort {$addresses{$b} <=> $addresses{$a}} keys %addresses)
	{
		$html.='<tr><td class="center">'.$i.'</td><td class="left">'.$addr.'</td><td class="center">'.$addresses{$addr}.'</td></tr>'."\n";
		last if ($i == $top);
		$i++;
	}
	$html.='</table>'."\n";
	$html.='<br/>'."\n";
	# 
	$i = 1;
	$html.='<table class="gridtable">'."\n";
	$html.='<caption>'.'IP identificadas en lista negra'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>IP</th><th>Incidencias</th><th>Blacklist?</th></tr>'."\n";
	foreach my $addr (sort {$blacklistedAddresses{$a} <=> $blacklistedAddresses{$b}} keys %blacklistedAddresses)
	{
		$html.='<tr><td class="center">'.$i.'</td><td class="left">'.$addr.'</td><td class="center">'.$blacklistedAddresses{$addr}.'</td><td class="center">'.'OK'.'</td></tr>'."\n";
		last if ($i == $top);
		$i++;
	}
	$html.='</table>'."\n";
	$html.='<br/>'."\n";
}

sub two
{
	# 
	my $i = 1;
	$html.='<table class="gridtable">'."\n";
	$html.='<caption>'.'Top '.$top.' dominios fuente de SPAM'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>IP</th><th>Incidencias</th></tr>'."\n";
	foreach my $d (sort {$domains{$b} <=> $domains{$a}} keys %domains)
	{
		$html.='<tr><td class="center">'.$i.'</td><td class="left">'.$d.'</td><td class="center">'.$domains{$d}.'</td></tr>'."\n";
		last if ($i == $top);
		$i++;
	}
	$html.='</table>'."\n";
	$html.='<br/>'."\n";
}

sub three
{
	# 
	my $i = 1;
	$html.='<table class="gridtable">'."\n";
	$html.='<caption>'.'Top '.$top.' Dominios mas atacados'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>IP</th><th>Incidencias</th></tr>'."\n";
	foreach my $d (sort {$dst_domains{$b} <=> $dst_domains{$a}} keys %dst_domains)
	{
		$html.='<tr><td class="center">'.$i.'</td><td class="left">'.$d.'</td><td class="center">'.$dst_domains{$d}.'</td></tr>'."\n";
		last if ($i == $top);
		$i++;
	}
	$html.='</table>'."\n";
	$html.='<br/>'."\n";
}

sub four
{
	# 
	my $i = 1;
	$html.='<table class="gridtable">'."\n";
	$html.='<caption>'.'Top '.$top.' Subjects'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>Subject</th><th>Incidencias</th></tr>'."\n";
	foreach my $item (sort {$subjects{$b} <=> $subjects{$a}} keys %subjects)
	{
		$html.='<tr><td class="center">'.$i.'</td><td class="left">'.$item.'</td><td class="center">'.$subjects{$item}.'</td></tr>'."\n";
		last if ($i == $top);
		$i++;
	}
	$html.='</table>'."\n";
	$html.='<br/>'."\n";
	
	# 
	$i = 1;
	$html.='<table class="gridtable">'."\n";
	$html.='<caption>'.'Subjects identificados en listas negras'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>Subject</th><th>Incidencias</th><th>Blacklist</th><th>Patron</th></tr>'."\n";
	foreach my $item (sort {$blacklistedSubjects{$b} <=> $blacklistedSubjects{$a}} keys %blacklistedSubjects)
	{
		my $matches = isBlacklistedSubject($item);
		$matches =~ s/\t/<br\/>/g;
		$html.='<tr><td class="center">'.$i.'</td><td class="left">'.$item.'</td><td class="center">'.$blacklistedSubjects{$item}.'</td><td class="center">'.'OK'.'</td><td class="center">'.$matches.'</td></tr>'."\n";
		last if ($i == $top);
		$i++;
	}
	$html.='</table>'."\n";
	$html.='<br/>'."\n";
}

sub five
{
	# 
	my $i = 1;
	$html.='<table class="gridtable">'."\n";
	$html.='<caption>'.'URL de lista negra'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>Dominio</th><th>Incidencias</th><th>Blacklist Dominio</th><th>Blacklist Patron</th></tr>'."\n";
	foreach my $item (sort {$url{$b} <=> $url{$a}} keys %url)
	{
		if ($url_blacklisted_domain{$item} or $url_blacklisted_pattern{$item})
		{
			my $dom;
			my $pat;
			if ($url_blacklisted_domain{$item})
			{
				$dom = $url_blacklisted_domain{$item};
				$dom =~ s/\n/<br\/>/g;
			}
			else
			{
				$dom = "";
			}
			if ($url_blacklisted_pattern{$item})
			{
				$pat = $url_blacklisted_pattern{$item};
				$pat =~ s/\n/<br\/>/g;
			}
			else
			{
				$pat = "";
			}
			
			$html.='<tr><td class="center">'.$i.'</td><td class="center">'.$item.'</td><td class="center">'.$url{$item}.'</td><td class="center">'.$dom.'</td><td class="center">'.$pat.'</td></tr>'."\n";
			last if ($i == $top);
			$i++;
		}
	}
	$html.='</table>'."\n";
	$html.='<br/>'."\n";
}

sub six
{
	# 
	my $i = 1;
	$html.='<table class="gridtable">'."\n";
	$html.='<caption>'.'Top '.$top.' Archivos'.'</caption>'."\n";
	$html.='<tr><th>#</th><th>Archivo</th><th>Incidencias</th><th>Descargado</th><th>URL</th></tr>'."\n";
	#foreach my $item (%hash)
	#{
	#	$html.='<tr><td class="center">'.$i.'</td><td class="center">'.$item.'</td><td class="center">'."###".'</td><td class="center">'."OK".'</td><td class="center">'."https://localhost:443/".'</td></tr>'."\n";
	#	last if ($i == $top);
	#	$i++;
	#}
	$html.='</table>'."\n";
	$html.='<br/>'."\n";
}

sub seven
{
		$html.='<a href="/Perl/files/">Archivos adjuntos</a>'."\n";
}

# = ^ . ^ =
1;

=Begin NaturalDocs
	Package: spamproc::html
	Description: 
=cut
