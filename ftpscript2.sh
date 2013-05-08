SSHPASS=test12

( echo "dir"; echo "bye" ) | sshpass -e sftp test@localhost > /dev/null 2>&1
#echo "exit status:" $?
exit 
