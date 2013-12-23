#!/bin/sh

if [ ! -f fw.sh ]; then
	echo "fw.sh does not exist. exiting."
	exit 1
fi

P1="$1"

case "$1" in 
	virgin)
		sed -i -e "s/^#LOCAL_ROUTER=\"192.168.0.1\"/LOCAL_ROUTER=\"192.168.0.1\"/" fw.sh
		sed -i -e "s/^LOCAL_ROUTER=\"192.168.1.1\"/#LOCAL_ROUTER=\"192.168.1.1\"/" fw.sh
		sed -i -e "s/^OUT_DNS1=$LOCAL_ROUTER/#OUT_DNS1=$LOCAL_ROUTER/" fw.sh
		sed -i -e "s/^OUT_DNS2=\"8.8.4.4\"/#OUT_DNS2=\"8.8.4.4\"/" fw.sh
		sed -i -e "s/^#OUT_DNS1=\"194.168.4.100\"/OUT_DNS1=\"194.168.4.100\"/" fw.sh
		sed -i -e "s/^#OUT_DNS2=\"194.168.8.100\"/OUT_DNS2=\"194.168.8.100\"/" fw.sh
		;;
	three)
		sed -i -e "s/^#LOCAL_ROUTER=\"192.168.1.1\"/LOCAL_ROUTER=\"192.168.1.1\"/" fw.sh 
		sed -i -e "s/^LOCAL_ROUTER=\"192.168.0.1\"/#LOCAL_ROUTER=\"192.168.0.1\"/" fw.sh
		sed -i -e "s/^#OUT_DNS1=$LOCAL_ROUTER/OUT_DNS1=$LOCAL_ROUTER/" fw.sh
		sed -i -e "s/^#OUT_DNS2=\"8.8.4.4\"/OUT_DNS2=\"8.8.4.4\"/" fw.sh
		sed -i -e "s/^OUT_DNS1=\"194.168.4.100\"/#OUT_DNS1=\"194.168.4.100\"/" fw.sh
		sed -i -e "s/^OUT_DNS2=\"194.168.8.100\"/#OUT_DNS2=\"194.168.8.100\"/" fw.sh
		;;
	phone)
		sed -i -e "s/^LOCAL_ROUTER=\"192.168.1.1\"/#LOCAL_ROUTER=\"192.168.1.1\"/" fw.sh
		sed -i -e "s/^#LOCAL_ROUTER=\"192.168.43.1\"/LOCAL_ROUTER=\"192.168.43.1\"/" fw.sh
		;;
	*)
		echo "No changes to script. Usage: fw.sh [virgin|three|phone]"
		;;
esac

exit 0
