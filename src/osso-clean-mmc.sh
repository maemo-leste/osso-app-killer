#!/bin/sh

if [ "x$USER" = "xroot" ]; then
  SUDO=''
  echo "$0: Warning, I'm root"
else
  SUDO='sudo'
fi

DEV=''
HOST=`hal-find-by-property --key mmc_host.slot_name --string internal`
if [ $? = 0 ]; then
  RCA=`hal-find-by-property --key info.parent --string $HOST`
  if [ $? = 0 ]; then
    STOR=`hal-find-by-property --key info.parent --string $RCA`
    if [ $? = 0 ]; then
      TMP=`hal-get-property --udi $STOR --key block.device`
      if [ $? = 0 ]; then
        DEV=$TMP
      fi
    fi
  fi
fi
if [ "x$DEV" != "x" ]; then
  echo "Internal memory card device is $DEV"
  $SUDO /bin/umount /media/mmc2
  if [ $? = 0 ]; then
    $SUDO /usr/sbin/osso-prepare-partition.sh $DEV
    if [ $? = 0 ]; then
      $SUDO /sbin/mkdosfs "${DEV}p1"
    fi
  fi
else
  echo "Could not find out internal memory card device"
fi
