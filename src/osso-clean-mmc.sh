#!/bin/sh
set +e

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

  # Wait until memory card is not used by applications
  INC=1
  while lsof /media/mmc2 > /dev/null; do
    if [ $INC -gt 10 ]; then
      echo "$0: memory card still used after 10 seconds"
      break
    fi
    sleep 1
    INC=`expr $INC + 1`
  done

  $SUDO /etc/init.d/ke-recv stop

  # Wait until ke-recv has exited
  INC=1
  while pidof ke-recv > /dev/null; do
    if [ $INC -gt 10 ]; then
      echo "$0: ke-recv still running after 10 seconds"
      break
    fi
    sleep 1
    INC=`expr $INC + 1`
  done

  $SUDO /bin/umount /media/mmc2
  $SUDO /usr/sbin/osso-prepare-partition.sh $DEV
  if [ $? = 0 ]; then
    $SUDO /sbin/mkdosfs "${DEV}p1"
  fi
else
  echo "Could not find out internal memory card device"
fi
