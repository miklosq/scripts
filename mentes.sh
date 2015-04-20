#!/bin/sh
# Filename: mentes.sh
# Author: Miklos Quartus

#BACKUPDIR=/media/usb0
BACKUPDIR=/media/qmi/b783dafc-feb8-4c46-920c-35bbff6180cf

echo "backup script" $0 "started."
#grep -q "/media/usb0" /etc/mtab || {
#	echo $0 error: "backup device is not mounted. Exiting (1)."
#	exit 1
#}

echo "preparing directories..."

[ -d $BACKUPDIR/backup ] || {
	echo $0 error: "$BACKUPDIR does not exist. Exiting (2)."
	exit 2
}

cd $BACKUPDIR/backup
rm -rf qmi.2
mv qmi.1 qmi.2
mv qmi.0 qmi.1
cp -al qmi.1 qmi.0
cd $HOME; cd ..
echo "backing up qmi's home..."
if [ -f /var/backups/qmi.exclude ] ; then
	/usr/bin/rsync -av --exclude-from=/var/backups/qmi.exclude --delete qmi/.  $BACKUPDIR/backup/qmi.0
else
	/usr/bin/rsync -av --delete qmi/.  $BACKUPDIR/backup/qmi.0
fi
echo -n "qmi.0 size in Mb is ===> "
du -sm $BACKUPDIR/backup/qmi.0

echo "backup script" $0 "done."
exit 0
