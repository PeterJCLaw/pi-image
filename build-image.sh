#!/bin/bash

set -e

cp /tmp/raspbian-base.img ./raspbian-base.img
IMAGE=raspbian-base.img
TARGET=raspbian-base

sha1sum $IMAGE

mkdir $TARGET
kpartx -av $IMAGE
mount /dev/mapper/loop0p2 $TARGET

cp /usr/bin/qemu-arm-static $TARGET/usr/bin/qemu-arm-static
cp pi-main.sh $TARGET/main.sh
# Disable ld preload
mv $TARGET/etc/ld.so.preload ./ld.so.preload

chroot $TARGET /main.sh

rm $TARGET/main.sh
rm $TARGET/usr/bin/qemu-arm-static
mv ./ld.so.preload $TARGET/etc/ld.so.preload

umount $TARGET
sync

kpartx -d $IMAGE

sha1sum $IMAGE

cp $IMAGE pi-image.img
