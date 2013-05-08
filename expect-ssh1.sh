PATH=/usr/bin

function hop_on_orwell {

CMD="ssh test@orwell uptime"
expect -c "
   spawn $CMD
   expect {
      "*password:*" { send test12\r; interact } 
   }
   exit
"
}

hop_on_orwell
echo "exit status:" $?

exit 
