#!/bin/sh --posix
# File: atnev2.sh
# Desc: atnevezes regularis kifejezessel aktualis konyvtarban
for i in *; do mv $i `echo $i | sed -e "s/\.csh/\.tcsh/"` ; done
