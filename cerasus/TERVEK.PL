#!/usr/bin/perl -w
#
# tervek.pl - CGI program automatikus html oldal-generalasra
# Quartus Miklós - programozó, Cerasus Bútor Kft.
# Szukseges fajlok: tervekh.lan v. terveke.lan a nyelvkodok beillesztesehez

use CGI qw/:standard :html3/;
use DBI;

$hiv = $ENV{'HTTP_REFERER'};
$kliens_ip = $ENV{'REMOTE_ADDR'};
$browzer = $ENV{'HTTP_USER_AGENT'};

$progi = new CGI;
$alak = $progi->param('alak');
$mereta = $ma = $progi->param('hosszer');
$meretb = $mb = $progi->param('hosszkr');
#$funkcio = $progi->param('funkcio');
$magassag = $mag = $progi->param('legnm');
#$tipus = $progi->param('tipus');
#$modell = $progi->param('modell');
#$megjegyzes = $progi->param('megjegyzés');
$mehet_gomb = $progi->param('mehet_gomb');
$oszlopszam = 7;
$index = 1;
my %NYELV_KOD;

substr($hiv, 0, -17) = "";
$nyelv_fajl = $hiv eq "demoh/tervek.html" ? "tervekh.lan" : "terveke.lan";

open( NY_FAJL, "<$nyelv_fajl" ) || die "nem nyithato meg: $nyelv_fajl!";
while ( <NY_FAJL> ) {
	$NYELV_KOD{$index} = $_;
	$NYELV_KOD{$index} =~ s/[0-9]//g; 
	$index++;
}
close ( NY_FAJL );

if ( not defined $mehet_gomb or ( $mehet_gomb ne "Mehet!" and $mehet_gomb ne "Go!" ) ) {
	print header('text/html');
	print "Csaltál! ";
	print "Itt vagy most: $kliens_ip ";
	print "Brówzered típusa: $browzer";
	print h4("A Cerasus minden ilyen és ehhez hasonló próbálkozást cyberterrorizmusnak könyvel el
		és az elkövetõkkel szemben jogi és egyéb eszközökkel szankciókat alkalmazhat.");
###	while( ($k, $e) = each(%NYELV_KOD)) {
###		print "$k -> $e<BR>";
###	}
	undef %NYELV_KOD;
	exit 0; 
}

if ( not defined $mereta or $mereta eq "" ) {
	$mereta = "32767";
	$ma = $NYELV_KOD{1};
}
if ( not defined $meretb or $meretb eq "" ) {
	$meretb = "32767";
	$mb = $NYELV_KOD{1};
}

if ( not defined $magassag or $magassag eq "" ) {
	$magassag = "32767";
	$mag = $NYELV_KOD{1};
}

if ( $alak eq "E" ) {
	$al = $NYELV_KOD{2};
} elsif ( $alak eq "B" ) {
	$al = $NYELV_KOD{3};	
} elsif ( $alak eq "J" ) {
	$al = $NYELV_KOD{4};
}
	
#
#if ( $funkcio eq "DS" ) {
#	$fu = "dolgozószoba";
#} elsif ( $funkcio eq "ES" ) {
#	$fu = "elõszoba";
#} elsif ( $funkcio eq "ET" ) {
#	$fu = "étkezõ"
#} elsif ( $funkcio eq "GY" ) {
#	$fu = "gyerekszoba"
#} elsif ( $funkcio eq "HS" ) {
#	$fu = "hálószoba"
#} elsif ( $funkcio eq "AS" ) {
#	$fu = "kisasztalok"
#} elsif ( $funkcio eq "KO" ) {
#	$fu = "komódok"
#} elsif ( $funkcio eq "NS" ) {
#	$fu = "nappali szoba"
#} elsif ( $funkcio eq "TA" ) {
#	$fu = "tálaló"
#} elsif ( $funkcio eq "TV" ) {
#	$fu = "tévé-hifi"
#} elsif ( $funkcio eq "VT" ) {
#	$fu = "vitrines"
#} else {
#	$fu = " -nem meghatározott- ";
#}
#
#if ( $tipus eq "E" ) {
#	$ti = "egyenes";
#} elsif ( $tipus eq "L" ) {
#	$ti = "lépkedõ";
#}
#
#if ( $modell eq "S" ) {
#	$mo = "Standard";
#} elsif ( $modell eq "C" ) {
#	$mo = "Cabinet";
#}

print header('text/html');
print start_html(-background=>"/stone.jpg",-title=>$NYELV_KOD{5});
print "<CENTER>";
print "<FONT SIZE =+1 COLOR=red><B>$NYELV_KOD{6}</B></FONT>";
print "</CENTER>";
print p;
print "<FONT SIZE =+1>$NYELV_KOD{7}</FONT>";
print "<FONT COLOR=brown><B>$al</B></FONT><BR>";

print "<FONT SIZE =+1>$NYELV_KOD{8}</FONT>";
print "<FONT COLOR=brown><B>$ma </B></FONT>";
print "<FONT SIZE =+1 COLOR=black>$NYELV_KOD{31}</FONT><BR>";


print "<FONT SIZE =+1>$NYELV_KOD{9}</FONT>";
print "<FONT COLOR=brown><B>$mb </B></FONT>";
print "<FONT SIZE =+1 COLOR=black>$NYELV_KOD{31}</FONT><BR>";

print "<FONT SIZE =+1>$NYELV_KOD{10}</FONT>";
print "<FONT COLOR=brown><B>$mag </B></FONT>";
print "<FONT SIZE =+1 COLOR=black>$NYELV_KOD{31}</FONT><BR>";

# print "<FONT SIZE =+1>$NYELV_KOD{11}</FONT>";
# print "<FONT COLOR=brown><B>$fu</B></FONT><BR>";
# print "<FONT SIZE =+1>$NYELV_KOD{12}</FONT>";
# print "<FONT COLOR=brown><B>$ti</B></FONT><BR>";
# print "<FONT SIZE =+1>$NYELV_KOD{13}</FONT>";
# print "<FONT COLOR=brown><B>$mo</B></FONT><BR>";
print p;

$dbh = DBI->connect("DBI:Pg:dbname=tervek");
if ($dbh) { 
	$sth =
#		$dbh->prepare(" SELECT * FROM tervek WHERE alak = '$alak' AND mereta <= $mereta
#			AND meretb <= $meretb
#			AND funkcio like '%$funkcio%'
#			AND magassag <= $magassag
#			AND tipus = '$tipus'
#			AND modell = '$modell'
#			  ORDER BY azo ");
		$dbh->prepare(" SELECT * FROM tervek
			WHERE alak = '$alak'
				AND mereta <= $mereta
				AND meretb <= $meretb
				AND magassag <= $magassag
			  ORDER BY azo ");
	$return = $sth->execute();
	if ($return) {
		&tabla_nyitas;
		&tabla_sorok;
		&tabla_zaras;
		$sth->finish();
	} else {
     	print h1($DBI::errstr);
	}
	$dbh->disconnect();
} else {
     print h1($DBI::errstr);
}
print "<CENTER><BR>";
print "<FONT SIZE=-1 COLOR=red><I>$NYELV_KOD{14}</I><P>";
print "<IMG SRC=\"/images/logo.gif\" ALT=\"logo.gif (1K)\"><BR>";
print "<FONT SIZE=-1 COLOR=black>$NYELV_KOD{15}</FONT>";
print end_html();
undef %NYELV_KOD;

##############################################################
#     				Szubrutinok                         #  
##############################################################

sub tabla_nyitas {
	print "<TABLE BORDER WIDTH=\"100%\" TITLE=\"Cerasus tabla\">\n";
	print "<CAPTION>$NYELV_KOD{16}</CAPTION>\n";
	print "<THEAD>";
	print "<TR><TH COLSPAN=$oszlopszam SCOPE=\"col\">$NYELV_KOD{17}\n";
	print "<TR>";
	print "<TH SCOPE=\"col\">$NYELV_KOD{18}\n";
####	print "<TH SCOPE=\"col\">Alak<P>\n";
	print "<TH SCOPE=\"col\">$NYELV_KOD{20}\n";
	print "<TH SCOPE=\"col\">$NYELV_KOD{21}\n";
####	print "<TH SCOPE=\"col\">$NYELV_KOD{22}\n";
	print "<TH SCOPE=\"col\">$NYELV_KOD{23}\n";
####	print "<TH SCOPE=\"col\">$NYELV_KOD{24}\n";
####	print "<TH SCOPE=\"col\">$NYELV_KOD{25}\n";
	print "<TH SCOPE=\"col\">$NYELV_KOD{26}\n";
	print "<TH SCOPE=\"col\">$NYELV_KOD{27}\n";
	print "<TH SCOPE=\"col\">$NYELV_KOD{28}\n";
}
sub tabla_sorok {
	print "<TBODY>\n";
	my($i, $sorok);
	$sorok_szama = 0;
####	while ( ($sorok = $sth->fetchrow_arrayref) && ($sorok_szama <= 50) ) {
	while ( (@sorok = $sth->fetchrow_array) && ($sorok_szama < 50) ) {
####		print "<TR><TD>", join("</TD><TD>", @$sorok),  "</TD></TR>\n";
		$kepf = $sorok[10];
		$tervf = $sorok[11];
		substr($kepf, 0, 11) = "";
		substr($tervf, 0, 12) = "";
		print "<TR><TD>$sorok[0]</TD>	
		           <TD>$sorok[2]</TD>	
		           <TD>$sorok[3]</TD>	
		           <TD>$sorok[5]</TD>	
		           <TD>$sorok[9]</TD>	
		           <TD><A HREF=\"$sorok[10]\">$kepf</A></TD>	
		           <TD><A HREF=\"$sorok[11]\">$tervf</A></TD></TR>\n";	
		$sorok_szama += 1;
	}
}
sub tabla_zaras {
	print "<TFOOT>\n";
	print "<TR><TH COLSPAN=$oszlopszam SCOPE=\"col\">$NYELV_KOD{29} $sorok_szama $NYELV_KOD{30}\n";
	print "</TABLE>\n";
}
