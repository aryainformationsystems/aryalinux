#!/bin/bash

set -e
set +h

VERSION=1.0

CURRENT_DIR=$(pwd)
pushd ~/sources

wget -nc https://github.com/dosfstools/dosfstools/releases/download/v4.2/dosfstools-4.2.tar.gz
wget -nc https://ftpmirror.gnu.org/which/which-2.23.tar.gz
wget -nc https://deb.debian.org/debian/pool/main/o/os-prober/os-prober_1.84.tar.xz
wget -nc https://github.com/rhboot/efivar/archive/39/efivar-39.tar.gz
wget -nc https://www.linuxfromscratch.org/patches/blfs/13.0/efivar-39-upstream_fixes-1.patch

wget -nc https://github.com/rhboot/efibootmgr/archive/18/efibootmgr-18.tar.gz
wget -nc https://downloads.sourceforge.net/freetype/freetype-2.14.1.tar.xz
wget -nc https://unifoundry.com/pub/unifont/unifont-17.0.03/font-builds/unifont-17.0.03.pcf.gz
wget -nc https://mj.ucw.cz/download/linux/pci/pciutils-3.14.0.tar.gz
wget -nc https://ftp.osuosl.org/pub/rpm/popt/releases/popt-1.x/popt-1.19.tar.gz
wget -nc https://mirrors.edge.kernel.org/pub/linux/kernel/firmware/linux-firmware-20260519.tar.xz
wget -nc https://ftpmirror.gnu.org/cpio/cpio-2.15.tar.bz2
wget -nc https://github.com/lfs-book/LSB-Tools/releases/download/v0.12/LSB-Tools-0.12.tar.gz
wget -nc https://busybox.net/downloads/busybox-1.36.1.tar.bz2
wget -nc https://ftpmirror.gnu.org/nettle/nettle-3.10.2.tar.gz
wget -nc https://ftpmirror.gnu.org/libtasn1/libtasn1-4.21.0.tar.gz
wget -nc https://github.com/p11-glue/p11-kit/releases/download/0.26.2/p11-kit-0.26.2.tar.xz
wget -nc https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.12.tar.xz
wget -nc https://ftpmirror.gnu.org/wget/wget-1.25.0.tar.gz
wget -nc https://www.sudo.ws/dist/sudo-1.9.17p2.tar.gz
wget -nc https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz
wget -nc https://github.com/lfs-book/make-ca/archive/v1.16.1/make-ca-1.16.1.tar.gz
wget -nc http://www.cacert.org/certs/root.crt
wget -nc http://www.cacert.org/certs/class3.crt
wget -nc https://hg.mozilla.org/projects/nss/raw-file/tip/lib/ckfw/builtins/certdata.txt
wget -nc https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz
wget -nc http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.13.1.tar.gz
wget -nc https://curl.se/download/curl-8.18.0.tar.xz
wget -nc https://github.com/dracutdevs/dracut/releases/download/056/dracut-056.tar.xz
wget -nc https://sourceware.org/ftp/lvm2/LVM2.2.03.38.tgz
wget -nc https://raw.githubusercontent.com/aryainformationsystems/patches/$VERSION/0.21-nvme_ioctl.h.patch
wget -nc https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/mdocml/1.14.6-1/mdocml_1.14.6.orig.tar.gz

pushd $CURRENT_DIR/../applications
git checkout $VERSION
git pull
tar -czf alps-scripts-$VERSION.tar.gz *.sh
popd

mv -f $CURRENT_DIR/../applications/alps-scripts-$VERSION.tar.gz .

wget -nc https://downloads.sourceforge.net/cdrtools/cdrtools-3.02a09.tar.bz2
wget -nc https://ftp.gnu.org/gnu/xorriso/xorriso-1.5.8.pl02.tar.gz
wget -nc https://cmake.org/files/v4.2/cmake-4.2.3.tar.gz
wget -nc https://github.com/plougher/squashfs-tools/releases/download/4.7.5/squashfs-tools-4.7.5.tar.gz
wget -nc http://downloads.sourceforge.net/infozip/unzip60.tar.gz
wget -nc https://raw.githubusercontent.com/aryainformationsystems/patches/$VERSION/unzip-6.0-consolidated_fixes-1.patch
wget -nc https://github.com/dylanaraps/neofetch/archive/refs/tags/7.1.0.tar.gz -O neofetch-7.1.0.tar.gz

set +e

wget -nc https://github.com/aryainformationsystems/alps/releases/download/v1.0/alps-1.0.tar.gz

set -e

popd
