#!/bin/sh

cd /var/db/mysql/wordpress
for i in `ls wp_miklos_info*`
do
   e=$(echo $i | sed -e "s/wp_miklos_info_/wp_libren_hu_/")
   cp -v $i $e
   #echo $e
done
exit 0 
