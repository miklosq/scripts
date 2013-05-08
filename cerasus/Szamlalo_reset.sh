#!/bin/tcsh -e
# szaml_reset
# A honlap statisztikat rendbe rakja. A lokalis ip cimmel tortent latogatasokat eltavolitja a 
# stat fajlbol, a szamot levonja a szamlalobol. Quartus Miklos - Cerasus, 2000.04.26

set statfajl = /tmp/stat
set szamlalo = /tmp/szamlalo

@ lokal = `grep 192.168.0 /tmp/stat | wc -l`
@ latk = `cat /tmp/szamlalo` 
@ eredmeny = $latk - $lokal 

grep -v 192.168.0 $statfajl > $statfajl.uj
mv $statfajl.uj $statfajl
chown nobody.www $statfajl
chmod ug+w $statfajl
echo $eredmeny > $szamlalo

#echo szaml_reset: lefutott.
exit 0
