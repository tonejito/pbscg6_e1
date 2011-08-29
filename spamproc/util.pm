#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc::util;

our $verbose;

use spamproc::config;
use spamproc::log;

# Se utiliza exporter para exportar las variables definidas en el arreglo EXPORT
require Exporter;  
our @ISA = qw(Exporter);  
our @EXPORT=qw(checkFile checkDir openFiles closeFiles $LOGFILE buildBlacklist printBlacklist);

########	########	########	########	########	
#	check_file - 
sub checkFile
{
	my $mode = shift;
	my $filename = shift;
	# Read
	if ($mode eq "<" and -e $filename and -r $filename)
	{
		logmsg(*STDERR,"$filename exists and is readable") if ($verbose);
		return 1;
	}
	# Write
	if ($mode eq ">")
	{
		if (-w $filename or not -e $filename)
		{
			logmsg(*STDERR,"$filename is writable or doesn't exist") if ($verbose);
			return 1;
		}
	}
	return 0;
}

########	########	########	########	########	
#	Verifica el directorio de salida
sub checkDir
{
	my $dir = shift;
	unless (-e $dir and -w $dir)
	{
		logmsg(*STDERR,"creating directory $dir") if ($verbose);
		mkdir $dir;
	}
}

########	########	########	########	########	
#	
sub openFiles
{
	# Abre el archivo de log
	open($LOGFILE,">",$logfile);
	# Abre los archivos de entrada
	open($INPUT,"<",$input) if (checkFile("<",$input));
	open($DOMAIN_BL,"<",$domain_bl) if (checkFile("<",$domain_bl));
	open($PATTERN_BL,"<",$pattern_bl) if (checkFile("<",$pattern_bl));
	open($IP_BL,"<",$ip_bl) if (checkFile("<",$ip_bl));
	# Abre los archivos de salida
	open($OUTFILE,">",$outfile) if (checkFile(">",$outfile));
	open($OUT_URL,">",$out_url) if (checkFile(">",$out_url));
	open($USRFILE,">",$usrfile) if (checkFile(">",$usrfile));
}

########	########	########	########	########	
#	
sub closeFiles
{
	# Cierra los archivos de entrada
	close($_) foreach ($INPUT, $DOMAIN_BL, $PATTERN_BL, $IP_BL);
	# Cierra los archivos de salida
	close($_) foreach ($OUTFILE, $OUT_URL, $USRFILE);
	# Cierra el archivo de log
	close($LOGFILE);
}

########	########	########	########	########	
#	
sub buildBlacklist
{
	while(<$DOMAIN_BL>)
	{
		chomp;
		$blacklist_domain{$_}++;
	}
	while(<$PATTERN_BL>)
	{
		chomp;
		$blacklist_pattern{$_}++;
	}
	while(<$IP_BL>)
	{
		chomp;
		$blacklist_ip{$_}++;
	}
}

########	########	########	########	########	
#	
sub printBlacklist
{
	separator "ip blacklist";
	print $_."\n" foreach (keys %blacklist_ip);
	
	separator "domain blacklist";
	print $_."\n" foreach (keys %blacklist_domain);
	
	separator "pattern blacklist";
	print $_."\n" foreach (keys %blacklist_pattern);
}

# = ^ . ^ =
1;

=Begin NaturalDocs
	Package: spamproc::util
	Description: 
=cut
