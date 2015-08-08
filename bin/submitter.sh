#!/bin/sh

if [ $# -ne 1 ]
then
 echo "\nUsage: submitter.sh filename\n"
 exit
fi
if [ ! -r $1 ]
then
 echo "File $1 does not exist\n"
 exit
fi


API_TOKEN=ag92eYhR22An9vEip08Za6VFZZ3ToZRYyw6jN/5nUYo=

cat $1

curl --user :$API_TOKEN -X POST -H "Content-Type: application/json" -d @"$1" https://davar.icfpcontest.org/teams/145/solutions
