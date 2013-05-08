#!/bin/csh

if ( $?status ) then
	echo "Az if kifejezes igaz," \$\?status "= $?status "
else
	echo "Az if kifejezes hamis, eredmenye: $?status "
endif
