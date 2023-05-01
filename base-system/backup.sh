#!/bin/bash

set -e
set +h

./umountal.sh

. ./build-properties

LABEL=$1
TOOLCHAIN_BACKUP=$2
sleep 5

mount $ROOT_PART $LFS

if [ ! -z "$HOME_PART" ]
then

mount $HOME_PART $LFS/home

fi

pushd /

if [ ! -f $LFS/sources/aryalinux-$OS_VERSION-$LABEL-$(uname -m).tar.gz ]
then

GZIP=-9 tar --exclude="$LFS/sources" \
	--exclude="$LFS/usr/share/doc/*" \
	--exclude="$LFS/tools" \
	--exclude="$LFS/root/.ccache" \
	--exclude="$LFS/root/.cargo" \
	--exclude="$LFS/home/$USERNAME/.ccache" \
	--exclude="$LFS/var/cache/alps/binaries" \
	--exclude="$LFS/var/cache/alps/sources" \
	--exclude="$LFS/usr/src/*" \
	-czvf $LFS/sources/aryalinux-$OS_VERSION-$LABEL-$(uname -m).tar.gz $LFS
	if [ "$TOOLCHAIN_BACKUP" == "y" ] || [ "$TOOLCHAIN_BACKUP" == "Y" ] && [ ! -f $LFS/sources/toolchain-$OS_VERSION-$(uname -m).tar.xz ] ; then
		XZ_OPT=-9 tar -cJvf $LFS/sources/toolchain-$OS_VERSION-$(uname -m).tar.xz $LFS/tools
	fi
fi

popd
