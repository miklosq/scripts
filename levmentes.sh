#!/bin/sh --posix
#
# levmentes.sh - Emailek mentese
# 
echo "levelek mentese sonnira..."
cd /
tar cf tmp/levelek.tar var/mail/qmi home/$USER/Mail --totals
gzip tmp/levelek.tar
scp tmp/levelek.tar.gz mquartus@sonni:NRClinux
rm tmp/levelek.tar.gz
echo kesz.
exit 0
