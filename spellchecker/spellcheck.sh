#!/bin/bash

for i in $(git diff-tree --no-commit-id --name-only -r HEAD | grep .tex);
do
    if [ "$i" != "config/config.tex" ] && [ "$i" != "config/package.tex" ] && [ "$i" != "main.tex" ]
    then
	echo "Checking file $i"
	tmp=$(cat $i | aspell -t -a --lang=$1 --add-extra-dicts="`pwd`/dictionary.$1.pws" | grep -v "*" | grep -v "@" | sed '/^\s*$/d')
	echo "List of errors detected for $i"
	echo "$tmp"
	echo "End of list for $i"
	res=$res$tmp
    fi
done

if [ "$res" != "" ]
then
  exit 1
else
  exit 0
fi
