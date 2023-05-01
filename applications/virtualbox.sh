#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:xserver-meta


cd $SOURCE_DIR

NAME=virtualbox
VERSION=nightly

SECTION="Virtualization"
DESCRIPTION="Oracle VM VirtualBox is a free and open-source hosted hypervisor for x86 virtualization, developed by Oracle Corporation. Created by Innotek GmbH, it was acquired by Sun Microsystems in 2008, which was, in turn, acquired by Oracle in 2010. VirtualBox may be installed on Windows, macOS, Linux, Solaris and OpenSolaris."


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

sudo pip install bs4

wget https://www.virtualbox.org/wiki/Linux_Downloads -O Linux_Downloads

cat > /tmp/parser.py<<"EOF"
from bs4 import BeautifulSoup

with open('Linux_Downloads') as fp:
	doc = BeautifulSoup(fp.read(), features="html.parser")

for anchor in doc.select('a[href]'):
	if 'All distributions' in str(anchor):
		print(anchor['href'])
EOF

url=$(python /tmp/parser.py)
tarball=$(echo $url | rev | cut -d/ -f1 | rev)

VBOX_INSTALLER=$(echo $url | rev | cut -d/ -f1 | rev)
VERSION=$(echo $VBOX_INSTALLER | cut -d "-" -f2)

wget -nc $url

chmod a+x $VBOX_INSTALLER

sudo ./$VBOX_INSTALLER

sudo ln -svf /opt/VirtualBox/virtualbox.desktop /usr/share/applications/
sudo update-desktop-database
sudo update-mime-database /usr/share/mime



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd