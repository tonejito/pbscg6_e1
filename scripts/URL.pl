#!/usr/bin/perl -w

#proyecto programacion en Perl

use strict;

package patrones;
our $file;
our $blackfile;
our $tld = '(a(ero|rpa|sia)|biz|c(at|om|oop)|edu|gov|i(nfo|nt)|jobs|m(il|obi|useum)|n(a(me|to)|et)|org|pro|t(el|ravel))';
our $cctld = '((a(c|d|e|f|g|i|l|m|n|o|q|r|s|t|u|w|x|z))|(b(a|b|d|e|f|g|h|i|j|m|n|o|r|s|t|v|w|y|z))|(c(a|c|d|f|g|h|i|k|l|m|n|o|r|s|u|v|x|y|z))|(d(d|e|j|k|m|o|z))|(e(c|e|g|h|r|s|t|u))|(f(i|j|k|m|o|r))|(g(a|b|d|e|f|g|h|i|l|m|n|p|q|r|s|t|u|w|y))|(h(k|m|n|r|t|u))|(i(d|e|l|m|n|o|q|r|s|t))|(j(e|m|o|p))|(k(e|g|h|i|m|n|p|r|w|y|z))|(l(a|b|c|i|k|r|s|t|u|v|y))|(m(a|c|d|e|g|h|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z))|(n(a|c|e|f|g|i|l|o|p|r|u|z))|(o(m))|(p(a|e|f|g|h|k|l|m|n|r|s|t|w|y))|(q(a))|(r(e|o|s|u|w))|(s(a|b|c|d|e|g|h|i|j|k|l|m|n|o|r|t|u|v|y|z))|(t(c|d|f|g|h|j|k|l|m|n|o|p|r|t|v|w|z))|(u(a|g|k|s|y|z))|(v(a|c|e|g|i|n|u))|(w(f|s))|(y(e|t))|(z(a|m|w)))';
our $domain_regex = '[\w\d]+(\.?[\w\d\-])*\.'.$tld.'(\.'.$cctld.')?';
our $protocol_regex = '(f|ht)tps?://' ;
our $path_regex = '[\w\d\-\/\+_.,:=#%]+';
our $url_regex = $protocol_regex.'('.$domain_regex.')'.$path_regex;
our %url;
our $tot_url;
our %direcciones = ();
our %blacklistedURL = ();

#logica del programa

open($file,"$ARGV[0]");

while(<$file>){
	chomp($_);
	if ($_ =~ /($url_regex)/)
	{
		$patrones::url{$1}++;
		$patrones::tot_url++;
	}
}

muestraResultados();


close($file);

#funciones del programa

sub muestraResultados
{
	if($tot_url != 0) {
				foreach my $elemento (sort{$patrones::url{$b} <=> $patrones::url{$a}} keys %patrones::url)
				{ 
					print  "|	$elemento	| $patrones::url{$elemento}	|	|\n";
				}
						
	}
}

sub isBlackListedURL
{
	my $direccion = shift;
	foreach my $entrada (keys %blacklist_url)
	{
		return $direccion if ($direccion eq $entrada);
	}
}

sub blacklistedSourceURLs
{
	foreach my $direccion (keys %direcciones)
	{
		$blacklistedURL{$direccion}++ if($direccion and isBlacListedURL($direccion));
	}
}

sub printSourceURL
{
	#logmsg($LOGFILE,"source URLs");
	#separator "source URL's";
	foreach my $key (sort{$direcciones{$b} <=> $direcciones{$a}} keys %direcciones)
	{
		#logmsg($LOGFILE,$key."\t".$direcciones{$key}) if ($verbose);
		print $key."\t".$direcciones{$key}."\n";
	}
}

sub printBlackListedURL
{
	#logmsg($LOGFILE,"blacklisted URL's");
	#separator "blacklisted URL's";
	foreach my $key (sort{$blacklistedURL{$a} <=> $blacklistedURL{$b}} keys %blacklistedURL)
	{
		#logmsg($LOGFILE,$key."\t".$blacklistedURL{$key}) if ($verbose);	
		print $key. "\t".$blacklistedURL{$key}."\n";
	}
}








