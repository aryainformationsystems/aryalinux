#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

NAME="kernel"
VERSION="5.5.2"
DESCRIPTION="The Linux kernel is a free and open-source, monolithic, Unix-like operating system kernel."
URL="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.5.2.tar.xz"
SECTION="System"

cd $SOURCE_DIR
mkdir -pv $NAME
pushd $NAME

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY
wget http://aryalinux.info/artifacts/kernel-configs/$VERSION/config -O .config
make -j$(nproc)
sudo make modules_install
sudo cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-$VERSION
sudo cp -v .config /boot/config-$VERSION
sudo cp -v System.map /boot/System.map-$VERSION
MODULE_VERSION=$(grep "# Linux/x86" /boot/config-$VERSION | cut -d ' ' -f3)
sudo dracut -f /boot/initrd.img-$VERSION $MODULE_VERSION

cd ..
cp -r $DIRECTORY /usr/src/
sudo ln -svf /usr/src/$DIRECTORY /lib/modules/$MODULE_VERSION/build
sudo ln -svf /usr/src/$DIRECTORY /lib/modules/$MODULE_VERSION/source

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd