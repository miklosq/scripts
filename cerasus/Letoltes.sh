#!/bin/bash
#
# letoltes2.sh - QM

QUERY_STRING="name=Gipsz+Jakab&zip=8767&city=Budapest&address=Szel u. 5.&email=valaki@valahol.hu&\
phone=9879146001&purpose=Magancelu kiprobalas"

echo QUERY_STRING = $QUERY_STRING
sztring=$QUERY_STRING

for i in name zip city address email phone purpose
	do
		sztring=${sztring#*=}
		elem=${sztring%%&*}
		echo -n `echo $elem | tr + ' '` ' '  
	done

echo ""
exit 0
