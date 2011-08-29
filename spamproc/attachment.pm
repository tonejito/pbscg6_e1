#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc::attachment;

our $conf;
our $verbose;
our $input;
our $out_bindir;

use MIME::Parser;
use Mail::MboxParser;
use Mail::MboxParser::Mail;

use spamproc::config;
use spamproc::log;
use spamproc::regex;

# Se utiliza exporter para exportar las variables definidas en el arreglo EXPORT
require Exporter;  
our @ISA = qw(Exporter);  
our @EXPORT=qw(saveAttachments);

########	########	########	########	########	
#	
sub saveAttachments
{
	my $total = 0;
	my $mailbox = Mail::MboxParser->new($input,decode=>'ALL',parseropts=>"");
	
	while (my $msg = $mailbox->next_message)
	{
		$msg->store_all_attachments(path => $out_bindir);
		++$total;
	}
}

# = ^ . ^ =
1;

=Begin NaturalDocs
	Package: spamproc::attachment
	Description: 
=cut
