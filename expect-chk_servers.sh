#!/bin/bash
#
#       file:   chk_servers.sh
#
#       descr:  check of list of a servers by logging in via expect and execute chosen command
#       author: miklos quartus
#       copyright (c) 

function usage() {
        echo "Usage: $0 <IP list of servers file>"
}

IFILE=$1
if [ -z $IFILE ]; then usage; exit 1; fi
if [ ! -s $IFILE ]; then echo "Error: <IP list of servers file> cannot be opened or empty. Exiting."; usage; exit 2; fi
if [ ! -f .user.txt ]; then echo "Error: .user.txt is missing. Exiting."; usage; exit 3; fi

echo "`basename $0` started running..."
SDATE=`date +%Y%m%d-%H%M`
OUTFILE=outfile/chk_servers_outfile.$SDATE
[ -f $OUTFILE ] || touch $OUTFILE
SSH="ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -q4"
COMMAND="$(cat command.txt)"
USER="$(cat .user.txt)"
BOXES="$(cat $IFILE)"
NOOFBOXES="$(cat $IFILE | wc -l)"

echo "Executing command      ===>" $COMMAND
echo "on the following boxes ===>"
for host in $BOXES; do echo $host; done
echo "Total of" $NOOFBOXES "box(es) altogether."
echo "TO INTERRUPT, PRESS <CTRL-C> NOW!"
sleep 5s

for host in $BOXES; do
    printf "Connecting to $host...\n"
    ./execute $SSH $USER@$host "$COMMAND"
    if [ $? -eq 1 ] ; then
        echo "*** invalid password ***"
    fi
    if [ $? -eq 2 ] ; then
        echo "*** timeout ***"
    fi

done 2>&1 | tee -a $OUTFILE

echo "`basename $0` completed."
exit
