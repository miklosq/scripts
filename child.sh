#!/bin/sh
echo child.sh started. pid is $$.
trap 'echo child.sh exiting; exit' 0
trap 'echo child.sh got a signal 1' 1
trap '' 2       # ignore signal 2
trap 'echo child.sh got a signal 3' 3
trap 'echo child.sh got a signal 15; tee /tmp/$$.out; exit' 15
#sleep 1000      # wait a long time for a signal
read a
