#!/usr/bin/perl 
#
# szamlalo.pl - CGI program automatikus html oldal-generalasra

$statisztika = "/tmp/stat";
$szamlalo = "/tmp/szamlalo";
$kapcsolo = $ENV{'QUERY_STRING'};
$DEBUG = 0;

if ( $kapcsolo eq "novel" ) {
	open(STAT, ">>$statisztika") || die "nem nyithato meg $!\n";
	($mp, $perc, $ora, $nap, $honap, $ev, $het_napja, $ev_napja, $nyari_idoszam) =
		localtime(time); 
	if ( $mp < 10 ) {$mp = "0$mp"};
	if ( $perc < 10 ) {$perc = "0$perc"};
	if ( $ora < 10 ) {$ora = "0$ora"};
	$ev += 1900;
    	@honapok = ( "Jan", "Feb", "Mar", "Apr", "Maj", "Jun", "Jul", "Aug", "Szep", "Okt", "Nov", "Dec");
	$honap_nev = $honapok[$honap];
	$datum = "$ev $honap_nev $nap $ora\:$perc\:$mp ";

	######## A stat fajl irasa
	##
	print STAT "$datum";
	print STAT $ENV{'REMOTE_HOST'};
	print STAT " ";
	print STAT $ENV{'REMOTE_ADDR'};
	print STAT " ";
	print STAT $ENV{'HTTP_USER_AGENT'};
	print STAT " ";
	print STAT $ENV{'REMOTE_USER'};
	print STAT " ";
	print STAT $ENV{'HTTP_REFERER'};
	print STAT "\n";
	close(STAT);

	if (! -f "$szamlalo") {
		$ertek = 0;
	}
	else {
		open(SZAML, "<$szamlalo") || die "nem nyithato meg $!\n";
		$ertek = <SZAML>;
		close(SZAML);
	}

	$ertek++;

	open(SZAML, ">$szamlalo") || die "nem nyithato meg $!\n";
	print SZAML "$ertek\n";
	close(SZAML);

 	print "Content-type: text/plain\n\n";
	if ( $DEBUG ) {
  		print "PATH_INFO: $ENV{'PATH_INFO'}\n";
  		print "QUERY_STRING: $ENV{'QUERY_STRING'}\n";
  		print "kapcsolo: $kapcsolo\n";
	} # DEBUG endif
	}

	if ( $kapcsolo eq "szamol" ) {
		open(SZAML, "<$szamlalo") || die "nem nyithato meg $!\n";
		$ertek = <SZAML>;
		close(SZAML);

 		print "Content-type: text/plain\n\n";
		$ertek =~ s/\n//;
		print "$ertek";
	if ( $DEBUG ) {
  	 	print "PATH_INFO: $ENV{'PATH_INFO'}\n";
  	 	print "QUERY_STRING: $ENV{'QUERY_STRING'}\n";
  		print "kapcsolo: $kapcsolo\n";
  	 	print "A SZAMLALO ALLASA: $ertek\n";
	} # DEBUG endif
	}

	if ( $kapcsolo eq "stat" ) {
		open(SZAML, "<$szamlalo")  || die "nem nyithato meg $!\n";
		$ertek = <SZAML>;
		close(SZAML);
		
		print "Content-type: text/html\n\n";
		print "<HTML>\n";
		print "<HEAD>\n";
		print "<TITLE>Latogatok adatai\n";
		print "</TITLE>\n";
		print "</HEAD>\n";
		print "<BODY>\n";

		print "<H1>Eddig $ertek latogato jart itt.</H1>\n";
		print "<H2>mikor, milyen IP cimrol, milyen bongeszovel, milyen hivatkozassal</H2>\n";
		print "<PRE>";

		open(STAT, "<$statisztika");
		while (<STAT>) {
			print;
		}
		close(STAT);
		print "</PRE>";
		print "</BODY>\n";
		print "</HTML>\n";
	}
exit 0;
