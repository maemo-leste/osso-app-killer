#!/bin/sh

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
  sudo umount /media/mmc2
  if [ $? = 0 ]; then
    sudo /usr/sbin/osso-prepare-partition.sh $DEV
    if [ $? = 0 ]; then
      sudo mkdosfs "${DEV}p1"
    fi
  fi
else
  echo "Could not find out internal memory card device"
fi
