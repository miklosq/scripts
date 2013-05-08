#!/bin/bash
# File: ekezetfix.sh
# Leiras: lecsereli a magyar ekezeteket a kodtablaban annak megfelelo szamkodra
# Szerzo: Quartus Miklós <qmi@libren.hu>

input=$1

if [ -z $input ]; then
   echo "Usage: $0 [fajl.txt]"
   exit 1
fi

echo -n "$0 fut..."
sed -e "s/á/\&#225;/g" \
    -e "s/Á/\&#193;/g" \
    -e "s/é/\&#233;/g" \
    -e "s/õ/\&#245;/g" \
    -e "s/ő/\&#245;/g" \
    -e "s/ó/\&#243;/g" \
    -e "s/ü/\&#252;/g" \
    -e "s/ö/\&#246;/g" \
    -e "s/ú/\&#250;/g" \
    -e "s/Ú/\&#218;/g" \
    -e "s/û/\&#251;/g" \
    -e "s/ű/\&#251;/g" \
    -e "s/í/\&#237;/g" \
    -e "s/Table of Contents/Tartalomjegyz\&#233;k/g" -i.bak $input

if [ "$?" -ne 0 ]; then
	echo "Hiba tortent, kilepes."
	exit 1
fi

echo "kesz."
exit 0
