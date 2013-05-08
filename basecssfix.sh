#!/bin/sh

echo "$0 fut..."

if [ -z "$1" -o -z "$2" ]; then
	echo "arg 1 is" $1
	echo "arg 2 is" $2
	echo "Hasznalat: $0 {.html} {1|2}"
	exit 1
fi

if [ ! -f "$1" ]; then
	echo "Hiba, $1 nem olvashato. Kilepes." 
	exit 2
fi

if [ "$2" -eq 1 ]; then
	grep -q "base\.css" $1
	if [ $? -eq 0 ]; then
		echo "Hiba, van mar base.css . Kilepes."
		exit 2
	else
		sed -e "1,4s/><TITLE/><link rel=\"stylesheet\" href=\"..\/base.css\" type=\"text\/css\"><TITLE/" $1 > /tmp/$$
	fi 
elif [ "$2" -eq 2 ]; then
	sed -e "s/base\.css/\.\.\/base\.css/" $1 > /tmp/$$
else 
	echo "Hiba: arg 2 nem {1|2}. Kilepes." 
	exit 2
fi

if [ "$?" -eq 0 ]; then cp /tmp/$$ $1
else
	echo "Hiba tortent, kilepes."
	exit 2
fi

echo "kesz."
exit 0
