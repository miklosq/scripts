#!/bin/sh

if [ -z "$1" ]; then
   echo -n "Which host do you want to connect to? -> "
   read -t 10 host
else
   host=$1
fi

if ! getent hosts $host > /dev/null; then echo "host is unknown. exiting."; exit 1; fi

ping -c 1 -q $host > /dev/null 2>&1
hostreachable=$?

if [ "$hostreachable" == 0 ]; then
   screen -ln -t "$host" ssh $host
else
   echo "Could not connect to '$host'. Exiting."
   exit 1
fi

exit 0
