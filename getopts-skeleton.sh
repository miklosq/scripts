#!/bin/bash

DEBUG=0
VERBOSITY=0
HELPMODE=0
FILEMODE=0
MYNAME=${0##*/}
noargs=false
exit_status=0
declare -a ARGUMENTS=()
declare -a ARGFILES=()

function usage() {
        printf "Usage:           $MYNAME [options] host\n"
        printf "Description:     \n"
        printf "Version:         1.0 beta\n"
        printf "\n"
        printf "Options:\n"
        echo  " -h              show brief help"
        echo  " -d              debug mode"
        echo  " -v              verbose mode"
}

while getopts "dhvf:" OPTION; do
        case $OPTION in
                d)   # debug mode
                        ((DEBUG++))
                        debug echo "DEBUG: debug option (-$OPTION) selected"
                        ;;
                h)   # help mode
                        ((HELPMODE++))
                        debug echo "DEBUG: help option (-$OPTION) selected"
                        debug echo "DEBUG: printing usage"
                        usage
                        exit_status=5
                        ;;
                v)   # verbose mode
                        debug echo "DEBUG: verbose option ($OPTION) selected"
                        ((VERBOSITY++))
                        ;;
                f)   # argument list in file
                        debug echo "DEBUG: hostlist file option ($OPTION) selected"
                        ((FILEMODE++))
                        oldIFS=$IFS IFS=","
                        ARGFILES+=($OPTARG)
                        IFS=$oldIFS
                        ;;
        esac
done

debug echo "DEBUG: script " $MYNAME "started ..."

for (( i=$OPTIND; i>1; i-- )); do
        shift
done
if [ ${#ARGFILES[*]} > 0 ]; then
        for i in ${ARGFILES[*]}; do
         [ $VERBOSITY -gt 0 ] && echo "started."
        # do something...
        exit_status=$?
        [ $VERBOSITY -gt 0 ] && echo "done."
done
[ $# -eq 0 ] && noargs=true
if [ $noargs == 'true' ]; then
        [ $HELPMODE -lt 1 ] && [ $FILEMODE -lt 1 ] && echo "Error: no args specified. Try -h for help."
        exit_status=5
else
        debug echo "DEBUG: arguments or options specified"
        #exit_status=7
fi

debug echo "DEBUG: script " $MYNAME "finished."
debug echo "DEBUG: Exiting with " $exit_status
exit $exit_status
