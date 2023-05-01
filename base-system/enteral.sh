#!/bin/bash

./umountal.sh &> /dev/null

RUNASUSER="$2"
COMMAND="$1"
PACKAGE="$3"

if [ -f /sources/build-properties ]
then
	. /sources/build-properties
elif [ -f ./build-properties ]
then
	. ./build-properties
	mount -v -t ext4 $ROOT_PART $LFS
fi

export LFS=/mnt/lfs
mkdir -pv $LFS

if [ "$HOME_PART" != "" ]
then
	mkdir -pv $LFS/home
	mount -v -t ext4 $HOME_PART $LFS/home
fi

if [ "$SWAP_PART" != "" ] && [ ! -z '`swapon -s | grep "$SWAP_PART"`' ]
then
	swapon -v $SWAP_PART
fi

mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

mount -vt tmpfs tmpfs $LFS/dev/shm

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash --login -e +h $*

