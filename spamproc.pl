#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc;

our $conf;
our $verbose;
our $logfile;

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

use spamproc::html;

printf("Content-Type: text/html;charset=utf-8\n");
printf("Cache-Control: max-age=1\n");
printf("Pragma: no-cache\n");
printf("Refresh: 3600\n");
printf("Retry-After: 600\n");
printf("Warning: May contain viruses\n");
printf("\n");

initialize();

#Magic
doIt();

#closeFiles();

########	########	########	########	########	
#	Parseo de los argumentos de linea de comandos
sub initialize
{
	separator "initialize" if ($debug);
	foreach my $arg (@ARGV)
	{
		# Separa la opcion y el valor
		my @option = split(/=/,$arg);
		
		# Importa la configuracion desde un archivo externo
		if ($option[1] and $option[0] eq '--conf' and -r $option[1])
		{
			$conf = $option[1];
			require $conf;
		}
		# Archivo de log
		$logfile	= $option[1] if ($option[1] and $option[0] eq '--logfile' );
		# Archivos de entrada
		$input		= $option[1] if ($option[1] and $option[0] eq '--file' );
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
	openFiles();
	checkDir($out_bindir);
	buildBlacklist();
}

########	########	########	########	########	
#	
sub doIt
{
	# Procesamiento multilinea
	while(<INPUT>)
	{
		chomp;
		# Procesa las lineas de destinatario
		# TODO Arreglar para que no solo haga match a la primer direccion de correo electronico.
		if ($_ =~ /$To_regex/)
		{
			$mails{$3}++;
			$dst_users{$4}++;
			$dst_domains{$5}++;
			logmsg($LOGFILE,$3) if ($verbose);
		}
		# Procesa todas las lineas received
		if ( $_ =~ /$Received_regex/ )
		{
			$keep = 1;
		}
		else
		{
			# Sigue procesando la siguiente linea si esta identada con espacios o tabuladores
			if ($keep && $_ =~ /$Received_line/ )
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
		if ($_ =~ /($ip_regex)/)
		{
			if (isIP($1))
			{
				$addresses{$1}++;
				logmsg($LOGFILE,$1) if ($verbose);
			}
		}
		# Agrega la linea al hash si se marco para ser procesada y si contiene un dominio
		if ($keep and $_ =~ /($domain_regex)/)
		{
			$domains{$1}++;
			logmsg($LOGFILE,$1) if ($verbose);
		}
		if ($_ =~ /$Subject_regex/)
		{
			$subjects{$1}++;
			$tot_subject++;
		}
	}
	#printBlacklist();
	# Domains
	processDomains();
	resolveDomains() if ($resolve);
	printResolvedDomains();
	printSourceAddresses();
	# Source Addresses
	backlistedSourceAddresses();
	printBlacklistedAddresses();
	# Mail Addresses
	processMailAddresses();
	# Subjects
	printSubjects();
	blacklistSubjects();
	printSubjectsBlacklist();
	# Attachments
	print "<hr/>\n";
	saveAttachments();
	report();
	print $html;
	print $OUTFILE $html;
}

# = ^ . ^ =

=begin NaturalDocs
	Package: spamproc
	Description: Programa principal. Proyecto Perl - Plan de Becarios de Seguridad en Cómputo 2011.
=cut
