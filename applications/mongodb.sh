#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:scons
#REQ:pyyaml


cd $SOURCE_DIR

NAME=mongodb
VERSION=4.2.2
URL=https://fastdl.mongodb.org/src/mongodb-src-r4.2.2.tar.gz
SECTION="Databases"
DESCRIPTION="MongoDB is a general purpose, document-based, distributed database built for modern application developers and for the cloud era. No database makes you more productive."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://fastdl.mongodb.org/src/mongodb-src-r4.2.2.tar.gz


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

sudo pip3 install psutil
sudo pip install psutil
sudo pip3 install Cheetah3
sudo pip install Cheetah
sudo groupadd -g 49 mongodb &&
sudo useradd -c "MongoDB User" -g mongodb -d /var/lib/mongodb \
        -u 49 mongodb
sudo mkdir -pv /var/lib/mongodb/
sudo mkdir -pv /var/run/mongodb/
sudo chown mongodb:mongodb /var/lib/mongodb/
sudo chown mongodb:mongodb /var/run/mongodb/

scons core --disable-warnings-as-errors -j$(nproc) install &&
sudo cp -v build/opt/mongo/mongo* /usr/bin

sudo tee /lib/systemd/system/mongodb.service<<EOF
[Unit]
Description=MongoDB Database Server
Documentation=https://docs.mongodb.org/manual
After=network.target

[Service]
User=mongodb
Group=mongodb
ExecStart=/usr/bin/mongod --config /etc/mongod.conf
PIDFile=/var/run/mongodb/mongod.pid
# file size
LimitFSIZE=infinity
# cpu time
LimitCPU=infinity
# virtual memory size
LimitAS=infinity
# open files
LimitNOFILE=64000
# processes/threads
LimitNPROC=64000
# locked memory
LimitMEMLOCK=infinity
# total threads (user+kernel)
TasksMax=infinity
TasksAccounting=false

# Recommended limits for for mongod as specified in
# http://docs.mongodb.org/manual/reference/ulimit/#recommended-settings

[Install]
WantedBy=multi-user.target
EOF
sudo cp debian/mongod.conf /etc/
sudo systemctl enable mongodb


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd