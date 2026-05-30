#!/bin/bash

set -e
set +h

. /sources/build-properties

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j `nproc`"
fi

SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="lvm2"
TARBALL="LVM2.2.03.38.tgz"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

PATH+=:/usr/sbin
./configure --prefix=/usr       \
            --enable-cmdlib     \
            --enable-pkgconfig  \
            --enable-udev_sync  &&
make

make -C tools install_tools_dynamic &&
make -C udev  install               &&
make -C libdm install

make install
make install_systemd_units

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE
fi
