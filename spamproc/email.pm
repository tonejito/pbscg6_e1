#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc::email;

our $conf;
our $verbose;

our %recipients = ();
our %mails = ();
our %dst_users = ();
our %dst_domains = ();

use spamproc::config;
use spamproc::log;
use spamproc::regex;

# Se utiliza exporter para exportar las variables definidas en el arreglo EXPORT
require Exporter;  
our @ISA = qw(Exporter);  
our @EXPORT=qw(%recipients %mails %dst_users %dst_domains processMailAddresses);

########	########	########	########	########	
#	
sub processMailAddresses
{
	logmsg($LOGFILE,"target email");
	separator "target email";
	foreach my $m (sort {$mails{$b} <=> $mails{$a}} keys %mails)
	{
		logmsg($LOGFILE,$m."\t".$mails{$m}) if ($verbose);
		print $m."\t".$mails{$m}."\n";
	}
	
	logmsg($LOGFILE,"target users");
	separator "target users";
	foreach my $user (sort {$dst_users{$b} <=> $dst_users{$a}} keys %dst_users)
	{
		logmsg($LOGFILE,$user."\t".$dst_users{$user}) if ($verbose);
		print $user."\t".$dst_users{$user}."\n";
	}
	
	logmsg($LOGFILE,"target domains");
	separator "target domains";
	foreach my $domain (sort {$dst_domains{$b} <=> $dst_domains{$a}} keys %dst_domains)
	{
		logmsg($LOGFILE,$domain."\t".$dst_domains{$domain}) if ($verbose);
		print $domain."\t".$dst_domains{$domain}."\n";
	}
}

# = ^ . ^ =
1;

=Begin NaturalDocs
	Package: spamproc::email
	Description: 
=cut
