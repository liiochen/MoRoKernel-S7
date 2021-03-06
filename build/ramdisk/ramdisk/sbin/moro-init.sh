#!/system/bin/sh
# 
# Init MoRoKernel
#

OLD_LOG="/data/morokernel.log"
MORO_DIR="/data/.morokernel"
LOG="$MORO_DIR/morokernel.log"

rm -f $LOG
rm -f $OLD_LOG

BB="/sbin/busybox"
RESETPROP="/sbin/magisk resetprop -v -n"


# Mount
$BB mount -t rootfs -o remount,rw rootfs
$BB mount -o remount,rw /system
$BB mount -o remount,rw /data
$BB mount -o remount,rw /

# Create morokernel folder
if [ ! -d $MORO_DIR ]; then
	$BB mkdir -p $MORO_DIR;
fi


(
	$BB echo $(date) "MoRo-Kernel LOG" >> $LOG
	$BB echo " " >> $LOG

	# Fake Knox 0
	$BB echo "## -- Fake Knox 0" >> $LOG
	$RESETPROP ro.boot.warranty_bit "0"
	$RESETPROP ro.warranty_bit "0"
	$BB echo " " >> $LOG

	# Fix safetynet
	$BB echo "## -- SafetyNet" >> $LOG
	$RESETPROP "ro.build.fingerprint" "samsung/hero2ltexx/hero2lte:8.0.0/R16NW/G935FXXU2ERD5:user/release-keys"
	$RESETPROP "ro.boot.veritymode" "enforcing"
	$RESETPROP "ro.boot.verifiedbootstate" "green"
	$RESETPROP "ro.boot.flash.locked" "1"
	$RESETPROP "ro.boot.ddrinfo" "00000001"
	$BB chmod 640 /sys/fs/selinux/enforce
	$BB chmod 440 /sys/fs/selinux/policy
	$BB echo " " >> $LOG


) 2>&1 | tee -a ./$LOG

$BB chmod 777 $LOG

# Unmount
$BB mount -t rootfs -o remount,ro rootfs
$BB mount -o remount,ro /system
$BB mount -o remount,rw /data
$BB mount -o remount,ro /

