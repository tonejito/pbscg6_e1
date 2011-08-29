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
	separator "subjects";
	foreach my $item (sort {$subjects{$b} <=> $subjects{$a}} keys %subjects)
	{
		logmsg($LOGFILE,$item."\t".$subjects{$item}) if ($verbose);
		print $item."\t".$subjects{$item}."\n";
	}
}

########	########	########	########	########	
#	
sub printSubjectsBlacklist
{
	logmsg($LOGFILE,"subjects blacklist");
	separator "subjects blacklist";
	#foreach my $item (sort {$blacklistedSubjects{$b} <=> $blacklistedSubjects{$a}} keys %blacklistedSubjects)
	print "bla\n";
	foreach my $item (keys %blacklistedSubjects)
	{
		logmsg($LOGFILE,$item."\t".$blacklistedSubjects{$item}) if ($verbose);
		print $item."\t".$blacklistedSubjects{$item}."\t".comparaBlackList($item)."\n";
	}
}

########	########	########	########	########	
#	
sub isBlacklistedSubject
{
	my $subj = shift;
	# Itera en la lista negra
	foreach my $entry (keys %blacklist_pattern)
	{
		# Agrega al hash de elementos en lista negra si se listo como malo.
		return $subj if ($subj  =~ /$entry/i);
	}
	return 0;
}

########	########	########	########	########	
#	
sub blacklistSubjects
{
	# Itera en todas las direcciones encontradas
	foreach my $subj (keys %subjects)
	{
		# Agrega al hash de elementos en lista negra si se listo como malo.
		$blacklistedSubjects{$subj}++ if (isBlacklistedSubject($subj));
	}
	isBlacklistedSubject("");
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
                	#print "|---------------------------------------|\n";
                        $ret .= "$_<br/>";
                        #$ret .= "\t$_<br/>";
                }
        }
        # Regresa al principio del archivo de lista negra
        seek($PATTERN_BL,0,0);
        $ret = 0 if ($ret eq "");
        return $ret;
}

# = ^ . ^ =
1;

=Begin NaturalDocs
	Package: spamproc::subjects
	Description: 
=cut
