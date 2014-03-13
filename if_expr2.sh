#!/bin/sh
# Note: this is arithmetic comparison! The "-eq" is an arithmetic binary operator

var=1
[ $var -eq 1 ] && {
echo i am running
echo so far
echo ok
}
