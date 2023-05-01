#!/bin/bash

set -e
set +h

VERSION=4.0

CURRENT_DIR=$(pwd)
pushd ~/sources

wget -nc https://github.com/dosfstools/dosfstools/releases/download/v4.2/dosfstools-4.2.tar.gz
wget -nc http://ftp.gnu.org/gnu/which/which-2.21.tar.gz
wget -nc https://deb.sipwise.com/debian/pool/main/o/os-prober/os-prober_1.79.tar.xz
wget -nc https://github.com/rhboot/efivar/releases/download/38/efivar-38.tar.bz2

wget -nc https://github.com/rhboot/efibootmgr/archive/17/efibootmgr-17.tar.gz
wget -nc https://downloads.sourceforge.net/freetype/freetype-2.9.tar.bz2
wget -nc https://ftp.gnu.org/gnu/unifont/unifont-7.0.05/unifont-7.0.05.pcf.gz
wget -nc https://www.kernel.org/pub/software/utils/pciutils/pciutils-3.5.5.tar.xz
wget -nc http://ftp.rpm.org/popt/releases/popt-1.x/popt-1.18.tar.gz
wget -nc https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-20220411.tar.gz
wget -nc https://ftp.gnu.org/gnu/cpio/cpio-2.13.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/$VERSION/0001-src-global.c-drop-duplicate-definition-of-program_na.patch
wget -nc https://ftp.osuosl.org/pub/blfs/conglomeration/LSB-Tools/LSB-Tools-0.9.tar.gz
wget -nc https://busybox.net/downloads/busybox-1.32.1.tar.bz2
wget -nc https://ftp.gnu.org/gnu/nettle/nettle-3.7.1.tar.gz
wget -nc https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.16.0.tar.gz
wget -nc https://github.com/p11-glue/p11-kit/releases/download/0.23.22/p11-kit-0.23.22.tar.xz
wget -nc https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.0.tar.xz
wget -nc https://ftp.gnu.org/gnu/wget/wget-1.21.1.tar.gz
wget -nc http://www.sudo.ws/dist/sudo-1.9.5p2.tar.gz
wget -nc https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tar.xz
wget -nc https://github.com/djlucas/make-ca/releases/download/v1.7/make-ca-1.7.tar.xz
wget -nc http://www.cacert.org/certs/root.crt
wget -nc http://www.cacert.org/certs/class3.crt
wget -nc https://hg.mozilla.org/projects/nss/raw-file/tip/lib/ckfw/builtins/certdata.txt
wget -nc http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-4.06.tar.xz
wget -nc http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.11.3.tar.gz
wget -nc https://curl.haxx.se/download/curl-7.75.0.tar.xz
wget -nc https://github.com/dracutdevs/dracut/releases/download/053/dracut-053.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/b09bd478061f93f986442bf654bb3fe8fadb59f7/efibootmgr-17-efidir.patch
wget -nc https://sourceware.org/ftp/lvm2/releases/LVM2.2.02.171.tgz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/$VERSION/squashfs-tools-4.3-sysmacros.patch
# wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/$VERSION/efivar-37-linking.patch
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/$VERSION/0001-squashfs-tools-fix-build-failure-against-gcc-10.patch
wget -nc https://sourceware.org/ftp/elfutils/0.170/elfutils-0.170.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.1/0.21-nvme_ioctl.h.patch
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/$VERSION/texinfo-6.8-end_line.patch
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/$VERSION/systemd-250-kernel_5.17_fixes-1.patch
wget -nc https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/mdocml/1.14.6-1/mdocml_1.14.6.orig.tar.gz

pushd $CURRENT_DIR/../applications
git checkout $VERSION
git pull
tar -czf alps-scripts-$VERSION.tar.gz *.sh
popd

mv -f $CURRENT_DIR/../applications/alps-scripts-$VERSION.tar.gz .

wget -nc https://sourceforge.net/projects/cdrtools/files/cdrtools-3.01.tar.bz2
wget -nc https://www.gnu.org/software/xorriso/xorriso-1.5.4.pl02.tar.gz
wget -nc https://cmake.org/files/v3.19/cmake-3.19.5.tar.gz
wget -nc https://sourceforge.net/projects/squashfs/files/squashfs/squashfs4.4/squashfs4.4.tar.gz
wget -nc http://downloads.sourceforge.net/infozip/unzip60.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/$VERSION/unzip-6.0-consolidated_fixes-1.patch

set +e

wget -c https://bitbucket.org/chandrakantsingh/alps-new/get/master.tar.bz2 -O alps-master.tar.bz2

set -e

popd
