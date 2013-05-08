awk -F\: '$3 > 499 &&  $3 < 65534 { print $1 }' /etc/passwd | sort
