#!/bin/sh

OLD_PWD=$(pwd)

set -x

DIR_TO_CLEAR=${HOME}/MyDocs

cd ${HOME}/MyDocs
for rmable in $(ls -A); do
  rm -rf $rmable
done

cd ${HOME}
for rmable in $(ls -A); do
 if test "x${rmable}" != "xMyDocs"; then
   rm -rf $rmable
 fi
done

cd ${OLD_PWD}
