#!/bin/sh
# Filename: mentes.sh
# Author: Miklos Quartus

BACKUPDIR=/media/usb0

echo "backup started."
if [ ! -d $BACKUPDIR ]; then
	echo "$BACKUPDIR is not mounted. exiting."
	exit 1
fi

echo "preparing directories..."
cd $BACKUPDIR/backup
rm -rf qmi.2
mv qmi.1 qmi.2
mv qmi.0 qmi.1
cp -al qmi.1 qmi.0
cd $HOME; cd ..
echo "backing up qmi's home..."
rsync -av --exclude-from=/var/backups/qmi.exclude --delete qmi/.  $BACKUPDIR/backup/qmi.0
echo -n "qmi.0 size is "
du -sm $BACKUPDIR/backup/qmi.0
echo "Mb."
echo "backing up root's home..."
cd /
sudo rsync -av --delete ./root/. $BACKUPDIR/backup/root/

echo "backup done."
exit 0
