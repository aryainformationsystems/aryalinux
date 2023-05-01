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
STEPNAME="003-os-prober.sh"
TARBALL="os-prober_1.79.tar.xz"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

make
mkdir -pv /usr/{lib,share}/os-prober
cp -v os-prober /usr/bin
cp -v linux-boot-prober /usr/bin
cp -v newns /usr/lib/os-prober
cp -v common.sh /usr/share/os-prober
mkdir -pv /usr/lib/linux-boot-probes/mounted
mkdir -pv /usr/lib/os-probes/{init,mounted}

cp -v linux-boot-probes/common/*         /usr/lib/linux-boot-probes
cp -v linux-boot-probes/mounted/common/* /usr/lib/linux-boot-probes/mounted
cp -v linux-boot-probes/mounted/x86/*    /usr/lib/linux-boot-probes/mounted

cp -v  os-probes/common/*         /usr/lib/os-probes
cp -v  os-probes/init/common/*    /usr/lib/os-probes/init
cp -v  os-probes/mounted/common/* /usr/lib/os-probes/mounted
cp -vR os-probes/mounted/x86/*    /usr/lib/os-probes/mounted

mkdir -pv /var/lib/os-prober


cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
