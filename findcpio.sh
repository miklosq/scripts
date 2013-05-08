# backup with find+cpio
#find . -depth -print | cpio -pmvd /var/tmp/miklos
#OR
cd ..; find ./miklos -depth -print | cpio -pmvd /var/tmp/
