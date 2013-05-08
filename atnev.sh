#!/bin/sh --posix
# File: atnev.sh
# Desc: atnevezes kiterjesztes alapjan

OLDEXT=JPG
NEWEXT=jpg

echo regi kiterjesztes: $OLDEXT
echo uj kiterjesztes: $NEWEXT

for i in *.$OLDEXT
do
echo -n '.'
mv $i `echo $i | sed "s/\(.*\)\.$OLDEXT/\1.$NEWEXT/"`
done

echo OK
exit 0
