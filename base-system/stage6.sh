. $LFS/sources/build-properties

LFS=/mnt/lfs

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

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

mount -vt tmpfs tmpfs $LFS/dev/shm


chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    bash --login /sources/stage7.sh
