#!/bin/sh

OLD_PWD=$(pwd)

set -x

# Set IFS to just newline
IFS='
'

DIR_TO_CLEAR=${HOME}/MyDocs

cd ${HOME}/MyDocs
for rmable in $(ls -A); do
  rm -rf "$rmable"
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
