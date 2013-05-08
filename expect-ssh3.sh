#!/usr/bin/expect -f
spawn ssh test@orwell 
match_max 100000
# Look for passwod prompt
expect "*?assword:*"
# Send password aka $password
send -- "test12\r"
# send blank line (\r)
expect "*]$?"
send -- "exit\r"
