#!/bin/bash

reporoot=$(git rev-parse --show-toplevel)
if [ -z "$NUM_MIN_SCHECK" ]
then
    min=6
else
    min=$NUM_MIN_SCHECK
fi
if [ -z "$NUM_MAX_SCHECK" ]
then
    max=90
else
    max=$NUM_MAX_SCHECK
fi
if [ -z "$2" ]
then
    texdir="/res/sections/*.tex"
else
    texdir=$2
fi
echo "Checking files in $reporoot$texdir"
for i in $reporoot$texdir
do
    filebasename=$(basename $i)
    filenumber=$(echo "$filebasename" | cut -f1 -d"-")
    if [ "$filenumber" -gt "$min" ]  && [ "$filenumber" -lt "$max" ]
    then
	      echo "Checking file $filebasename"
	      tmp=$(cat $i | aspell -t -a --lang=$1 --encoding=utf-8 --add-extra-dicts="$reporoot/dictionary.$1.pws" | grep -v "*" | grep -v "@" | grep -v "+" | sed '/^\s*$/d')
	      echo "List of errors detected for $filebasename"
	      echo "$tmp"
	      echo "End of list for $filebasename"
	      res=$res$tmp
    fi
done

if [ "$res" != "" ]
then
  exit 1
else
  exit 0
fi
