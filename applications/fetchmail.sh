#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:procmail


cd $SOURCE_DIR

NAME=fetchmail
VERSION=6.4.27
URL=https://downloads.sourceforge.net/fetchmail/fetchmail-6.4.27.tar.xz
SECTION="Mail/News Clients"
DESCRIPTION="The Fetchmail package contains a mail retrieval program. It retrieves mail from remote mail servers and forwards it to the local (client) machine's delivery system, so it can then be read by normal mail user agents."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://downloads.sourceforge.net/fetchmail/fetchmail-6.4.27.tar.xz


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

echo $USER > /tmp/currentuser


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
useradd -c "Fetchmail User" -d /dev/null -g nogroup \
        -s /bin/false -u 38 fetchmail
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

PYTHON=python3 \
./configure --prefix=/usr \
            --enable-fallback=procmail &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install                                  &&
chown -v fetchmail:nogroup /usr/bin/fetchmail
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat > ~/.fetchmailrc << "EOF"

# The logfile needs to exist when fetchmail is invoked, otherwise it will
# dump the details to the screen. As with all logs, you will need to rotate
# or clear it from time to time.
set logfile fetchmail.log
set no bouncemail
# You probably want to set your local username as the postmaster
set postmaster $(cat /tmp/currentuser)

poll SERVERNAME :
    user <isp_username> pass <password>;
    mda "/usr/bin/procmail -f %F -d %T";
EOF

touch ~/fetchmail.log       &&
chmod -v 0600 ~/.fetchmailrc


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd