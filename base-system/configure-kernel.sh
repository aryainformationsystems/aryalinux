#!/bin/bash

set -e
set +h

echo "Please proceed only if you know what you are doing."
echo "Even small changes in kernel configuration have unforseen consequences and may render the system unusable."
echo "Please be careful."
echo "In case you have doubts, please exit by pressing Ctrl + C"
echo "Or else press Enter to continue..."
echo ""
read xx

LINUX_TARBALL=$(grep kernel.org | grep linux | rev | cut -d/ -f1 | rev)
pushd ~/sources
LINUX_DIR=$(tar -tf $LINUX_TARBALL | cut -d/ -f1 | uniq)
tar xf $LINUX_TARBALL
cd $LINUX_DIR

tar xf ../aufs-*.tar.gz
for p in ../aufs*patch; do patch -Np1 -i $p; done
cp ~/aryalinux/base-system/config-64 .config

make menuconfig
cp .config ~/aryalinux/base-system/config-64

cd ~/sources
rm -rf $LINUX_DIR
popd

echo "I created a new kernel configuration file based on your inputs."

