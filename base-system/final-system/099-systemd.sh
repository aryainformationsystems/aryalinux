#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=099-systemd

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=systemd-253.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i -e 's/GROUP="render"/GROUP="video"/' \
       -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in
mkdir -p build
cd       build

meson --prefix=/usr                 \
      --buildtype=release           \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dldconfig=false              \
      -Dsysusers=false              \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=false                   \
      -Dmode=release                \
      -Dpamconfdir=no               \
      -Ddev-kvm-mode=0660           \
      -Ddocdir=/usr/share/doc/systemd-253 \
      ..
ninja
ninja install
tar -xf ../../systemd-man-pages-253.tar.xz --strip-components=1 -C /usr/share/man
systemd-machine-id-setup
systemctl preset-all
systemctl disable systemd-sysupdate{,-reboot}

fi

cleanup $DIRECTORY
log $NAME