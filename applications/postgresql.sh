#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=postgresql
VERSION=15.2
URL=https://ftp.postgresql.org/pub/source/v15.2/postgresql-15.2.tar.bz2
SECTION="Databases"
DESCRIPTION="PostgreSQL is an advanced object-relational database management system (ORDBMS), derived from the Berkeley Postgres database management system."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ftp.postgresql.org/pub/source/v15.2/postgresql-15.2.tar.bz2


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
groupadd -g 41 postgres &&
useradd -c "PostgreSQL Server" -g postgres -d /srv/pgsql/data \
        -u 41 postgres
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sed -i '/DEFAULT_PGSOCKET_DIR/s@/tmp@/run/postgresql@' src/include/pg_config_manual.h &&

./configure --prefix=/usr          \
            --enable-thread-safety \
            --docdir=/usr/share/doc/postgresql-15.2 &&
make
make DESTDIR=$(pwd)/DESTDIR install
install -d -o postgres $(pwd)/DESTDIR/tmp
pushd $(pwd)/DESTDIR/tmp
/etc/rc.d/init.d/postgresql stop
su postgres -c "../usr/bin/initdb -D /srv/pgsql/newdata"
su postgres -c "../usr/bin/pg_upgrade \
                    -d /srv/pgsql/data    -b /usr/bin \
                    -D /srv/pgsql/newdata -B ../usr/bin"
popd
rm -rf /srv/pgsql/data
mv /srv/pgsql/newdata /srv/pgsql/data
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install      &&
make install-docs
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm700 /srv/pgsql/data &&
install -v -dm755 /run/postgresql &&
chown -Rv postgres:postgres /srv/pgsql /run/postgresql
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
su postgres -c '/usr/bin/initdb -D /srv/pgsql/data'
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc https://ftp.osuosl.org/pub/blfs/conglomeration/blfs-bootscripts/blfs-bootscripts-20230101.tar.xz
tar xf blfs-bootscripts-20230101.tar.xz
cd blfs-bootscripts-20230101
sudo make install-postgresql
popd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd