#!/bin/bash

reporoot=$(git rev-parse --show-toplevel)
for i in "$reporoot"/res/sections/*.tex
do
    filebasename=$(basename $i)
    filenumber=$(echo "$filebasename" | cut -f1 -d"-")
    if [ "$filenumber" -gt "6" ]  && [ "$filenumber" -lt "90" ]
    then
	echo "Checking file $i"
	tmp=$(cat $i | aspell -t -a --lang=$1 --add-extra-dicts="$reporoot/dictionary.$1.pws" | grep -v "*" | grep -v "@" | grep -v "+" | sed '/^\s*$/d')
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
