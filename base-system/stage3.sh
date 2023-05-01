set -e
set +h

. $LFS/sources/build-properties

LFS=/mnt/lfs

chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac

mkdir -pv $LFS/{dev,proc,sys,run}

set +e
umount $LFS/dev/pts
umount $LFS/dev/shm
umount $LFS/dev
umount $LFS/sys
umount $LFS/proc
umount $LFS/run
set -e

# Create /dev/console and /dev/null if not done already

if [ ! -e $LFS/dev/console ]; then
	mknod -m 600 $LFS/dev/console c 5 1
fi
if [ ! -e $LFS/dev/null ]; then
	mknod -m 666 $LFS/dev/null c 1 3
fi

mount -v --bind /dev $LFS/dev

mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

mount -vt tmpfs tmpfs $LFS/dev/shm

# Building Final System

chroot "$LFS" /usr/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ '              \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    bash --login +h /sources/stage4.sh
