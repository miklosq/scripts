#!/bin/bash

myname=`basename $0`
echo $myname started...
echo "PID is " $$
trap "echo szignal 15 erkezett!" TERM;
trap "echo szignal 1 erkezett!" HUP;
trap "echo szignal 9 erkezett!" KILL;

read a
echo $myname done.

exit 0
