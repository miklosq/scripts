# /etc/csh.login: This file contains login defaults used by csh and tcsh.
# Set up some environment variables:

echo argc=$#, argv=$*
if ( -f valami ) echo valami letezik.
if ( $status ) then
	echo Baj van: $status. 
endif
