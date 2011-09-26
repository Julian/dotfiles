#!/bin/sh

if [ "$1" = "-v" ]; then
    EXTRAARG="-v"
fi

fetchmail -a -K $EXTRAARG >/dev/null 2>&1

if [ "$?" = "0" ]; then
    /usr/local/bin/growlnotify -n mutt -a Mail.app -m "New mail received" >/dev/null 2>&1
fi
