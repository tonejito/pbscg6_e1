#!/usr/bin/perl -w
use strict;
use warnings;

package spamproc::regex;

our $conf;
our $verbose;

# Se utiliza exporter para exportar las variables definidas en el arreglo EXPORT
require Exporter;  
our @ISA = qw(Exporter);  
our @EXPORT=qw($tld $cctld $domain_regex $protocol_regex $path_regex $url_regex $ip_regex $enclosed_ip_regex $user_regex $mail_regex $displayName $encodedDisplayName $To_regex $Received_regex $Received_line $Subject_regex);

# Expresiones regulares
# Dominios de internet
# http://en.wikipedia.org/wiki/List_of_Internet_top-level_domains
# Top Level Domain	
our $tld = '(a(ero|rpa|sia)|biz|c(at|om|oop)|edu|gov|i(nfo|nt)|jobs|m(il|obi|useum)|n(a(me|to)|et)|org|pro|t(el|ravel))';

# Country Code Top Level Domain	
our $cctld = '((a(c|d|e|f|g|i|l|m|n|o|q|r|s|t|u|w|x|z))|(b(a|b|d|e|f|g|h|i|j|m|n|o|r|s|t|v|w|y|z))|(c(a|c|d|f|g|h|i|k|l|m|n|o|r|s|u|v|x|y|z))|(d(d|e|j|k|m|o|z))|(e(c|e|g|h|r|s|t|u))|(f(i|j|k|m|o|r))|(g(a|b|d|e|f|g|h|i|l|m|n|p|q|r|s|t|u|w|y))|(h(k|m|n|r|t|u))|(i(d|e|l|m|n|o|q|r|s|t))|(j(e|m|o|p))|(k(e|g|h|i|m|n|p|r|w|y|z))|(l(a|b|c|i|k|r|s|t|u|v|y))|(m(a|c|d|e|g|h|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z))|(n(a|c|e|f|g|i|l|o|p|r|u|z))|(o(m))|(p(a|e|f|g|h|k|l|m|n|r|s|t|w|y))|(q(a))|(r(e|o|s|u|w))|(s(a|b|c|d|e|g|h|i|j|k|l|m|n|o|r|t|u|v|y|z))|(t(c|d|f|g|h|j|k|l|m|n|o|p|r|t|v|w|z))|(u(a|g|k|s|y|z))|(v(a|c|e|g|i|n|u))|(w(f|s))|(y(e|t))|(z(a|m|w)))';

# Dominio de internet
our $domain_regex = '[\w\d]+(\.?[\w\d\-])*\.(('.$tld.'(\.'.$cctld.')?)|'.$cctld.')';

# Protocolo asociado con la URL
our $protocol_regex = '(f|ht)tps?://' ;

# Ruta de la URL
our $path_regex = '[\w\d\-\/\+_.,:=#%]+';

# Expresion regular para URL
our $url_regex = $protocol_regex.'('.$domain_regex.')'.$path_regex;

# Direccion IP
our $ip_regex = '(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})';

# Direccion ip entre parentesis y corchetes
our $enclosed_ip_regex = '\(\[($ip_regex)\]\)';

# Porcion del usuario en un correo electronico
our $user_regex = '[\w\d]+[\w\d\-_.]*';

# Direccion de correo electronico
our $mail_regex = '('.$user_regex.')@('.$domain_regex.')';

# Display name
our $displayName = '\".*\"';

# Display name codificado
our $encodedDisplayName = '\=\?[\w\d\-_.]+\?.*\?\=';

# Destinatario RFC 821
our $To_regex = '^To:\ ('.$displayName.'|'.$encodedDisplayName.')?(\s+)?\<?('.$mail_regex.')\>?.*$';

# Recibido por RFC 821
our $Received_regex = '^Received:\ (.*)$';
our $Received_line = '^\s+\w(.*)$';

# Asunto RFC 821
our $Subject_regex = '^Subject:\ (.*)$';

# = ^ . ^ =
1;

=begin NaturalDocs
	Package: spamproc::domain
	Description: 
=cut
