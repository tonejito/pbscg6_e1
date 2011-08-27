#!/usr/bin/perl -w
use strict;
use warnings;

package TestConfig;

=Begin NaturalDocs
	Package: TestConfig
	Description: Utilizando las variables definidas de otros scripts utilizando 'use' y 'require'
=cut

# Importando variables desde un archivo externo
use PackageConfigExporter;
# Parseo de los argumentos de linea de comandos
foreach my $arg (@ARGV)
{
	my @option = split(/=/,$arg);
	print "\t".$option[0]."\t".$option[1]."\n";
	# Archivos de entrada
	$conf		= $option[1] if ($option[1] and $option[0] eq '--conf' );
	$logfile	= $option[1] if ($option[1] and $option[0] eq '--logfile' );
	$domain_bl	= $option[1] if ($option[1] and $option[0] eq '--domain_bl' );
	$pattern_bl	= $option[1] if ($option[1] and $option[0] eq '--pattern_bl' );
	$ip_bl		= $option[1] if ($option[1] and $option[0] eq '--ip_bl' );
	# Archivos de salida
	$outfile	= $option[1] if ($option[1] and $option[0] eq '--outfile' );
	$out_url	= $option[1] if ($option[1] and $option[0] eq '--out_url' );
	$usrfile	= $option[1] if ($option[1] and $option[0] eq '--usrfile' );
	# Directorio de salida
	$out_bindir	= $option[1] if ($option[1] and $option[0] eq '--out_bindir' );
}

logmsg("after parsing");
# Archivos de entrada
print "\$conf\t\t".$conf."\n";
print "\$logfile\t".$logfile."\n";
print "\$domain_bl\t".$domain_bl."\n";
print "\$pattern_bl\t".$pattern_bl."\n";
print "\$ip_bl\t\t".$ip_bl."\n";
# Archivos de salida
print "\$outfile\t".$outfile."\n";
print "\$out_url\t".$out_url."\n";
print "\$usrfile\t".$usrfile."\n";
# Directorio de salida
print "\$out_bindir\t".$out_bindir."\n";
print "\n";

# Abre los archivos de entrada
foreach my $file ($conf , $logfile , $domain_bl , $pattern_bl , $ip_bl)
{
	if (-e $file and -r $file)
	{
		logmsg("Opening\t".$file);
		open(FILE,"<".$file);
	}
	else
	{
		logmsg("Open failed\t".$file);
	}
}
# Abre los archivos de salida
foreach my $file ($outfile , $out_url , $usrfile)
{
	if (-w $file or not -e $file)
	{
		logmsg("Output file:\t".$file);
		open(FILE,">".$file);
	}
	else
	{
		logmsg("No output file:\t".$file);
		*FILE = *STDERR;
	}
}
# Verifica el directorio de salida
if (-e $out_bindir and -w $out_bindir)
{
	logmsg("outdir exists and its writable");
}
else
{
	logmsg("outdir doesn't exist or is not writable");
}

logmsg("testing");
print ""."\n";

########	########	########	########	########	
#	logmsg - 

sub logmsg
{
	my $msg= shift;
	# Obtiene el nombre de la funcion que llamo esta subrutina
	my $currentFunction = (caller(1))[3];
	# Si no hay funcion, entonces se esta llamando desde main
	$currentFunction = 'main' if (!$currentFunction);
	(my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst)=localtime(time);
	printf STDERR "[%02d-%02d-%04d %02d:%02d:%02d][$currentFunction] %s\n",$mon+1,$mday,$year+1900,$hour,$min,$sec,$msg;
}

# = ^ . ^ =
