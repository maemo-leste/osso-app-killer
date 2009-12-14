#!/bin/sh

OLD_PWD=$(pwd)

set -x

# Set IFS to just newline
IFS='
'

cd ${HOME}/MyDocs
DONT='(documents/User Guides)|(documents/maemo_software_copyright.pdf)|'
DONT=${DONT}'(cities)|(\./\.qf)|(\./\.n900\.ico)|(autorun\.inf)|'
DONT=${DONT}'(\./Mac OS)|(\./\._)|(\.VolumeIcon\.icns)|(\./\.sounds/Ringtones)'

for rmable in $(find ./ | sort -r | egrep -v "${DONT}"); do
  rm -f "$rmable"
done

cd ${HOME}
for rmable in $(ls -A); do
 if test "x${rmable}" != "xMyDocs"; then
   rm -rf "$rmable"
 fi
done

unset IFS

mkdir -p /home/user
cd /etc/skel
cp -a . /home/user
chown -R user:users /home/user

cd ${OLD_PWD}
