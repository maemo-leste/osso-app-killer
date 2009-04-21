#!/bin/sh

set -x

DIR_TO_CLEAR=${HOME}/MyDocs

for rmable in $(ls -A ${DIR_TO_CLEAR}); do
  rm -rf ${DIR_TO_CLEAR}/${rmable}
done
