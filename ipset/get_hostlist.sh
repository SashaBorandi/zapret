#!/bin/sh
# get domain list. not IP

SCRIPT=$(readlink -f $0)
EXEDIR=$(dirname $SCRIPT)

. "$EXEDIR/def.sh"

ZREESTR=$TMPDIR/zapret.txt
#ZURL=https://reestr.rublacklist.net/api/current
ZURL=https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv

curl -k --fail --max-time 300 --max-filesize 41943040 "$ZURL" >$ZREESTR ||
{
 echo reestr list download failed   
 exit 2
}
dlsize=$(wc -c "$ZREESTR" | cut -f 1 -d ' ')
if test $dlsize -lt 204800; then
 echo list file is too small. can be bad.
 exit 2
fi
(cut -s -f2 -d';' $ZREESTR | grep -a . | sed -re 's/^\*\.(.+)$/\1/' | awk '{ print tolower($0) }' ; cat $ZUSERLIST ) | sort -u >$ZHOSTLIST
rm -f $ZREESTR

# force tpws to reload if its running
killall -HUP tpws 2>/dev/null
