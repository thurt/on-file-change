#!/bin/bash
# run a command when a file changes
# 
# package dependencies: coreutils, inotify-tools
#
# this script uses inotifywait to get notified from the kernal when the file *might* have changed.
# it then checks if sha1sum is different, and executes the command.
# comparing sha1sums prevents issuing the command in cases where the file was saved but not changed.
#
# $1 - file to watch
# $2 - command to run if file has changed
file=$1

function getSha {
    sha1sum < "$file"
}

sha=$(getSha)
nsha=$(getSha)

while true
do 
    inotifywait -e close_write "$file" &> /dev/null
    nsha=$(getSha) 
    if [ "$sha" != "$nsha" ]
    then
        sha=$nsha
        $2
    fi
done
