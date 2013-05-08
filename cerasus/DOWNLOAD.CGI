#!/bin/sh
#
# Name: download.cgi
#
# MODOSITASI NAPLO
# 2000/02/24	qmi	Az 'Location' kulcsszo betetele az interaktiv honlap-generalas helyett. 
# 2000/04/07	qmi	A logfajl_iras() fuggveny betetele a naplozasi fajl konszolidalasara.
#
#   Define variables.

LOGFILE=/tmp/clients		# Logs the clients
TEMP1=/tmp/temp1$$	 		# Temporary file
HTTP_REFERER=${HTTP_REFERER#*//*/} # Levagja bal oldalrol a http://...elotagot. 

logfajl_iras() {

	sztring=$QUERY_STRING

	date +%Y%b%d%T%Z >> $LOGFILE
 	for i in name zip city address email phone purpose
 		do
 			sztring=${sztring#*=}
 			elem=${sztring%%&*}
 			echo -n `echo $elem | tr + ' '` ' ' >> $LOGFILE 
 		done
	echo "" >> $LOGFILE
}

echo $QUERY_STRING > $TEMP1
TST=`/usr/bin/awk -f filter.awk $TEMP1`
if  [ "$TST" = "2" ]
   then 
   logfajl_iras  # !!! itt hivja meg a fuggvenyt
   case "$HTTP_REFERER" in
	"demoh/dload.html" )
  		echo Location: /demoh/dload_ok.html
		echo
		;;
	"demoe/dload.html" )
  		echo Location: /demoe/dload_ok.html
		echo
		;;
	* ) 
		echo Content-type: text/plain
		echo
		echo Sikertelen letoltes. Irjon ide: cerasus@cerasus.hu.
		exit 1
		;;
   esac
else
   case "$HTTP_REFERER" in
	"demoh/dload.html" )
  		echo Location: /demoh/dload_hianyos.html
		echo
		;;
	"demoe/dload.html" )
  		echo Location: /demoe/dload_hianyos.html
		echo
		;;
	* ) 
		echo Content-type: text/plain
		echo
		echo Sikertelen letoltes. Irjon ide: cerasus@cerasus.hu.
		exit 1
		;;
   esac
fi
/bin/rm $TEMP1
exit 0
