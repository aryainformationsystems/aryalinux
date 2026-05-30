#!/bin/bash
#
# Neofetch 7.1.0 — bash system information tool (AryaLinux addition).
#
# Runtime dependencies (base LFS + prior extras):
#   Required : bash, coreutils, gawk, grep, sed, bc, procps-ng, util-linux
#   Provided : pciutils (final-system/092-grub.sh), alps (021-alps.sh)
#   Optional : X/GL tools for resolution, DE/WM, GPU; image backends (w3m, etc.)

set -e
set +h

. /sources/build-properties

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j `nproc`"
fi

SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="028-neofetch.sh"
TARBALL="neofetch-7.1.0.tar.gz"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)
tar xf $TARBALL
cd $DIRECTORY

make install PREFIX=/usr

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
