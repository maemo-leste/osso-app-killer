#!/bin/sh
# This file is part of osso-app-killer.
#
# Copyright (C) 2005-2007 Nokia Corporation. All rights reserved.
#
# Contact: Kimmo Hämäläinen <kimmo.hamalainen@nokia.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License 
# version 2 as published by the Free Software Foundation. 
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301 USA

is_empty()
{
  cmp $1 - << EOF
EOF
}

# remove empty directories and directories with only empty files
r_rmdir()
{
  local EMPTY=1
  local OLDDIR=`pwd`
  cd $1
  for f in `ls`; do
    if [ -d $f ]; then
      r_rmdir $f
    fi
  done
  for f in `ls`; do
    if [ -d $f ]; then
      EMPTY=0
    elif [ -f $f ]; then
      if ! is_empty $f; then
        EMPTY=0
      fi
    fi
  done
  cd $OLDDIR
  if [ $EMPTY = 1 ]; then
    echo "removing $1"
    rm -rf $1
  fi
}

empty_file()
{
  echo -n '' > $1
}

cd /etc/osso-af-init/gconf-dir
if [ $? = 0 ]; then
  for d in `ls`; do
    if [ "x$d" = "xschemas" ]; then
      continue
    elif [ "x$d" = "xsystem" ]; then
      # special handling for subdirectory 'system'
      if [ "x$CUD" != "x" ]; then
        for f in `find system -name *.xml`; do
          echo "$0: removing $f"
          empty_file $f
        done
        r_rmdir $d
        continue
      elif [ "x$CUD" = "x" ]; then
        for f in `find system -name *.xml`; do
          # in ROS, paths having 'system/bluetooth' are preserved
          echo "$f" | grep -e 'system\/bluetooth' > /dev/null
          if [ $? = 0 ]; then
            continue
          fi
          echo "$0: removing $f"
          empty_file $f
        done
        r_rmdir $d
        continue
      fi
    elif [ "x$d" = "xapps" ]; then
      # special handling for subdirectory 'apps'
      if [ "x$CUD" = "x" ]; then
        for f in `find apps -name *.xml`; do

          # in ROS, paths having 'telepathy' are preserved
          echo "$f" | grep -e 'telepathy' > /dev/null
          if [ $? = 0 ]; then
            continue
          fi

          # in ROS, paths having 'hildon-desktop/applets' are preserved
          echo "$f" | grep -e 'hildon-desktop/applets' > /dev/null
          if [ $? = 0 ]; then
            continue
          fi

          # in ROS, paths having 'modest/accounts' and 'modest/server_accounts'
          # are preserved
          echo "$f" | grep -E 'modest/(server_)?accounts' > /dev/null
          if [ $? = 0 ]; then
            continue
          fi

          # in ROS, paths having 'hildon-home' are preserved
          echo "$f" | grep -e 'hildon-home' > /dev/null
          if [ $? = 0 ]; then
            continue
          fi

          echo "$0: removing $f"
          empty_file $f
        done
        r_rmdir $d
        continue
      fi
    fi
    echo "$0: removing GConf subdirectory $d"
    rm -rf $d
  done
else
  echo "$0: 'cd' command failed, doing nothing"
fi
