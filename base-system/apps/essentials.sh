#!/bin/bash

set -e
set +h

USERNAME="$1"

#alps selfupdate
make-ca -g -f
alps updatescripts
su - $USERNAME -c "PKG_BUILDER=$1 alps install -ni bash-completion python2 python3 nano which wget make-ca ntfs-3g fuse lvm2 parted gptfdisk shadow libpwquality"
if ! grep "shadow=" /etc/alps/installed-list &> /dev/null
then
	echo "Essentials incomplete (shadow). Aborting..."
	exit 1
fi
PKG_BUILDER=$1 alps install -ni sudo
if ! grep "sudo=" /etc/alps/installed-list &> /dev/null
then
        echo "Essentials incomplete (sudo). Aborting..."
        exit 1
fi
su - $USERNAME -c "PKG_BUILDER=$1 alps install -ni usbutils pciutils openssh gobject-introspection libxml2 desktop-file-utils shared-mime-info ccache"
if ! grep "ccache=" /etc/alps/installed-list &> /dev/null
then
        echo "Essentials incomplete (ccache). Aborting..."
        exit 1
fi

