#!/bin//sh
# for e.g. rename all files that starts with "a" and have one or more digits with ".csv" extension
ls -1 | grep -E "a[0-9]+" | xargs -I '{}' mv '{}' '{}.csv'
