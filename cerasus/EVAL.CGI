#!/usr/bin/perl -w

use CGI;

$progi = new CGI;
$kerdes = $progi->param('kerdes');
$valasz = $progi->param('most');
print "Content-type: text/plain\n\n";
if ( not defined $kerdes or length($kerdes) == 0 ) {
	print "Nem irtal be kerdest!\n";
	exit 0;
}
if ( not defined $valasz or $valasz != "?" ) {
	print "Csaltal!\n";
	exit 0;
}
if ( $kerdes =~/[a-zA-Z\`]/) {
	print "Ne akarj betorni!\n";
	exit 0;
}
print "A kerdes: $kerdes\n";
print "A valasz: ", eval($kerdes), "\n";
