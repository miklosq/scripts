#!/bin/bash
# By Miklos Quartus <inbox@miklos.info>
# Desc: prints a list of unique IPs with TCP connections to the machine it’s running on;
# 	the number of connections per machine;
# 	excludes localhost;
# 	output is sorted by the number of connections.

/bin/netstat -tn | grep ^tcp | awk '{print $5}' | sed -e "s/:.*//" | sort | grep -v -E "127\.0\.0\.1|localhost" > /tmp/myfile_$$
echo "" >> /tmp/myfile_$$

n=0
uip=""
while read ipaddr ; do
  if [ "$uip" == "$ipaddr" ]; then	# string equals
      n=$((n+1))
  else
      [ $n == 0 ] || echo -n $n >> /tmp/res_$$
      [ -z $uip ] || echo " " $uip >> /tmp/res_$$
      uip=$ipaddr
      n=1
  fi
done < /tmp/myfile_$$

rm /tmp/myfile_$$

cat /tmp/res_$$ | sort -rn 
rm /tmp/res_$$

exit
