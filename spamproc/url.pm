#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc::url;

our $conf;
our $verbose;
our %url = ();
our %url_blacklisted_domain = ();
our %url_blacklisted_pattern = ();

use spamproc::config;
use spamproc::log;
use spamproc::regex;

# Se utiliza exporter para exportar las variables definidas en el arreglo EXPORT
require Exporter;  
our @ISA = qw(Exporter);  
our @EXPORT=qw(%url %url_blacklisted_domain %url_blacklisted_pattern checkDomainBlacklist checkPatternBlacklist printURLDomain printDomainBlacklisted printPatternBlacklisted);

# Check if the url is from a blacklisted domain
sub checkDomainBlacklist
{
	foreach my $addr (keys %url)
	{
		foreach my $domain (keys %blacklist_domain)
		{
			$url_blacklisted_domain{$addr} .= $1."\n" if ($addr =~ /($domain)/i);
		}
	}
}

# Check if the url is from a blacklisted pattern
sub checkPatternBlacklist
{
	foreach my $addr (keys %url)
	{
		foreach my $patt (keys %blacklist_pattern)
		{
			$url_blacklisted_pattern{$addr} .= $1."\n" if ($addr =~ /($patt)/i);
		}
	}
}

sub printURLDomain
{
	foreach my $item (keys %url)
	{
		print $item."\t".$url{$item}."\n";
	}
}

sub printDomainBlacklisted
{
	foreach my $item (keys %url_blacklisted_domain)
	{
		print $item."\t".$url_blacklisted_domain{$item}."\n";
	}
}

sub printPatternBlacklisted
{
	foreach my $item (keys %url_blacklisted_pattern)
	{
		print $item."\t".$url_blacklisted_pattern{$item}."\n";
	}
}

# = ^ . ^ =
1;

=begin NaturalDocs
	Package: spamproc::url
	Description: 
=cut
