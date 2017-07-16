#!/bin/bash

set -e

if [ -f /tmp/raspbian-base.img ]; then
    echo "Not rerunning image prebuild"
    exit 0
fi

unzip raspbian.zip
IMAGE=$(ls *-raspbian-*.img)
TARGET=raspbian-base

sha1sum $IMAGE

mkdir $TARGET
kpartx -av $IMAGE
mount /dev/mapper/loop0p2 $TARGET

cp /usr/bin/qemu-arm-static $TARGET/usr/bin/qemu-arm-static
cp pi-prebuild.sh $TARGET/prebuild.sh
# Disable ld preload
mv $TARGET/etc/ld.so.preload ./ld.so.preload

chroot $TARGET /prebuild.sh

echo "Cleaning up"

rm $TARGET/prebuild.sh
rm $TARGET/usr/bin/qemu-arm-static
mv ./ld.so.preload $TARGET/etc/ld.so.preload

sleep 4

lsof $TARGET
umount $TARGET
sync

kpartx -d $IMAGE

sha1sum $IMAGE

cp $IMAGE /tmp/raspbian-base.img