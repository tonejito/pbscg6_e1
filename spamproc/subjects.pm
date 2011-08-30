#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc::subjects;

our $conf;
our $verbose;
our %blacklistedSubjects;
our $PATTERN_BL;
our %subjects;
our $tot_subject=0;

use spamproc::config;
use spamproc::log;
use spamproc::regex;

# Se utiliza exporter para exportar las variables definidas en el arreglo EXPORT
require Exporter;  
our @ISA = qw(Exporter);  
our @EXPORT=qw(%subjects $tot_subject %blacklistedSubjects printSubjects printSubjectsBlacklist isBlacklistedSubject blacklistSubjects comparaBlackList);

########	########	########	########	########	
#	
sub printSubjects
{
	logmsg($LOGFILE,"subjects");
	separator "subjects" if ($debug);
	foreach my $item (sort {$subjects{$b} <=> $subjects{$a}} keys %subjects)
	{
		logmsg($LOGFILE,$item."\t".$subjects{$item}) if ($verbose);
		print $item."\t".$subjects{$item}."\n" if ($debug);
	}
}

########	########	########	########	########	
#	
sub printSubjectsBlacklist
{
	logmsg($LOGFILE,"subjects blacklist");
	separator "subjects blacklist" if ($debug);
	#foreach my $item (sort {$blacklistedSubjects{$b} <=> $blacklistedSubjects{$a}} keys %blacklistedSubjects)
	foreach my $item (keys %blacklistedSubjects)
	{
		logmsg($LOGFILE,$item."\t".$blacklistedSubjects{$item}) if ($verbose);
		print $item."\t".$blacklistedSubjects{$item}."\t".isBlacklistedSubject($item)."\n" if ($debug);
	}
}

########	########	########	########	########	
#	
sub isBlacklistedSubject
{
	my $subj = shift;
	my $ret;
	# Itera en la lista negra
	foreach my $entry (keys %blacklist_pattern)
	{
		# Agrega al hash de elementos en lista negra si se listo como malo.
		$ret.=$entry."\t" if ($subj  =~ /$entry/i);
	}
	return undef if (!$ret);
    return $ret;
}

########	########	########	########	########	
#	
sub blacklistSubjects
{
	# Itera en todas las direcciones encontradas
	foreach my $subj (keys %subjects)
	{
		# Agrega al hash de elementos en lista negra si se listo como malo.
		$blacklistedSubjects{$subj} = $subjects{$subj} if (isBlacklistedSubject($subj));
	}
}

########	########	########	########	########	
#	
sub comparaBlackList
{
        my $elemento = shift;
	my $ret = "";
        while(<$PATTERN_BL>)
        {
                chomp;
                if($elemento =~ /$_/i)
                {
                	$ret .= "$_<br/>";
                }
        }
        # Regresa al principio del archivo de lista negra
        seek($PATTERN_BL,0,0);
        return undef if ($ret eq "");
        return $ret;
}

# = ^ . ^ =
1;

=Begin NaturalDocs
	Package: spamproc::subjects
	Description: 
=cut
