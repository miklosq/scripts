#!/bin/sh

file=/etc/postfix/canonical

if [ -f $file ]; then
case "$1" in
	home)
		sed -i.bak -e "s/\ .*/ inbox@miklos.info/" $file
		/usr/sbin/postmap $file
		;;
	work)
		sed -i.bak -e "s/\ .*/ qmi@libren.hu/" $file
		/usr/sbin/postmap $file
		;;
	list)
		sed -i.bak -e "s/\ .*/ qmil@libren.hu/" $file
		/usr/sbin/postmap $file
		;;
	*)
		echo "Hasznalat: $0 {home|work|list}"
		;;
esac

else
   echo "$file nem letezik."
fi

exit 0 
