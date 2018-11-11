#!/bin/bash

# Script that creates a "diary" of sorts for all git repos specified on the command line. 
# Commits from all branches of all repos are organized chronologically and divided into 1-day blocks.

temp=`mktemp`

for repo in "$@"
do
  git -C $repo log --pretty=format:%aI\ [%an\ %h]\ ${repo##*/}:\ %s --branches >> $temp
  printf "\n" >> $temp
done

cat $temp | sort | awk '{ n = split($1, mdy, "[-T:]"); if (mdy[1] != yold || mdy[2] != mold || mdy[3] != dold) { printf("\n%s-%s-%s\n==========\n", mdy[1], mdy[2], mdy[3]); yold = mdy[1]; mold = mdy[2]; dold = mdy[3];} $1=""; print substr($0,2);}' | less
