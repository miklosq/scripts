/usr/bin/expect -c "
   spawn /usr/bin/ssh test@orwell
   expect {
      "*password:*" { send test12\r; interact } 
   }
   exit
"
