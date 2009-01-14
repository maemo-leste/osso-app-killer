#!/bin/sh
# Common script for RFS/ROS and CUD.
#
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

DIR=/etc/osso-af-init
DEFAULT_LOCALE_DIR=/usr/share/osso-af-init

if [ "x$CUD" != "x" ]; then
  # restore the original language
  cat $DEFAULT_LOCALE_DIR/locale.orig > $DIR/locale
  if test $(id -u) -eq 0; then
    chown user:users $DIR/locale
  fi
fi

if ! dbus-send --system --type=method_call --dest="com.nokia.mce"  --print-reply "/com/nokia/mce/request"  com.nokia.mce.request.req_reboot; then
     dbus-send --system --type=method_call --dest="com.nokia.dsme" --print-reply "/com/nokia/dsme/request" com.nokia.dsme.request.req_reboot
fi
exit 0
