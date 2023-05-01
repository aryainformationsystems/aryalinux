#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=apparmor
VERSION=latest

DESCRIPTION="AppArmor protects systems from insecure or untrusted processes by running them in restricted confinement, while still allowing processes to share files, exercise privilege and communicate with other processes. AppArmor is a Mandatory Access Control (MAC) mechanism which uses the Linux Security Module (LSM) framework. The confinement's restrictions are mandatory and are not bound to identity, group membership, or object ownership. The protections provided are in addition to the kernel's regular access control mechanisms (including DAC) and can be used to restrict the superuser."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")



if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

git clone https://gitlab.com/apparmor/apparmor.git
cd apparmor
pushd ./libraries/libapparmor
sh ./autogen.sh
sh ./configure --prefix=/usr --with-perl --with-python
make
sudo make install
popd

pushd binutils
make
sudo make install
popd

pushd parser
make
sudo make install
popd

pushd utils
make
sudo make install
popd

pushd changehat/pam_apparmor
make
sudo make install
popd

pushd profiles
make
sudo make install
popd



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd