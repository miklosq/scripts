#!/bin/sh
echo parent.sh started. pid is $$

trap "echo parent.sh exiting; exit" 0
trap : 1                              # pass signal 1 to child but don't die
trap "" 2                             # ignore signal 2, block from child
trap "echo parent.sh got signal 15 | tee /tmp/$$.out" 15   # ignore signal 15, send to child
                                      # die on other signals, send to child
bash child.sh
echo parent.sh still running after child exited

sleep 60
