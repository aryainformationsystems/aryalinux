#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:perl-modules#perl-archive-zip
#REQ:unzip
#REQ:wget
#REQ:which
#REQ:zip
#REQ:boost
#REQ:clucene
#REQ:cups
#REQ:curl
#REQ:dbus-glib
#REQ:libepoxy
#REQ:libjpeg
#REQ:llvm
#REQ:glm
#REQ:glu
#REQ:gpgme
#REQ:graphite2
#REQ:gst10-plugins-base
#REQ:gtk3
#REQ:harfbuzz
#REQ:icu
#REQ:libatomic_ops
#REQ:lcms2
#REQ:librsvg
#REQ:libtiff
#REQ:libwebp
#REQ:libxml2
#REQ:libxslt
#REQ:python-modules#lxml
#REQ:mesa
#REQ:nss
#REQ:openldap
#REQ:poppler
#REQ:redland
#REQ:unixodbc


cd $SOURCE_DIR

NAME=libreoffice
VERSION=7.5.2.2
URL=https://download.documentfoundation.org/libreoffice/src/7.5.2/libreoffice-7.5.2.2.tar.xz
SECTION="Office Programs"
DESCRIPTION="LibreOffice is a full-featured office suite. It is largely compatible with Microsoft Office and is descended from OpenOffice.org."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.documentfoundation.org/libreoffice/src/7.5.2/libreoffice-7.5.2.2.tar.xz
wget -nc https://download.documentfoundation.org/libreoffice/src/7.5.2/libreoffice-dictionaries-7.5.2.2.tar.xz
wget -nc https://download.documentfoundation.org/libreoffice/src/7.5.2/libreoffice-help-7.5.2.2.tar.xz
wget -nc https://download.documentfoundation.org/libreoffice/src/7.5.2/libreoffice-translations-7.5.2.2.tar.xz


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


install -dm755 external/tarballs &&
ln -sv ../../../libreoffice-dictionaries-7.5.2.2.tar.xz external/tarballs/ &&
ln -sv ../../../libreoffice-help-7.5.2.2.tar.xz         external/tarballs/ &&
ln -sv ../../../libreoffice-translations-7.5.2.2.tar.xz external/tarballs/
ln -sv src/libreoffice-help-7.5.2.2/helpcontent2/ &&
ln -sv src/libreoffice-dictionaries-7.5.2.2/dictionaries/ &&
ln -sv src/libreoffice-translations-7.5.2.2/translations/
export LO_PREFIX=/usr
case $(uname -m) in
   i?86) sed /-Os/d -i solenv/gbuild/platform/LINUX_INTEL_GCC.mk ;;
esac
export ac_cv_lib_gpgmepp_progress_callback=yes
sed -e "/gzip -f/d"   \
    -e "s|.1.gz|.1|g" \
    -i bin/distro-install-desktop-integration &&

sed -e "/distro-install-file-lists/d" -i Makefile.in &&

./autogen.sh --prefix=$LO_PREFIX         \
             --sysconfdir=/etc           \
             --with-vendor=AryaLinux          \
             --with-lang=ALL --without-java      \
             --with-help                 \
             --with-myspell-dicts        \
             --without-junit             \
             --without-system-dicts      \
             --disable-dconf             \
             --disable-odk               \
             --enable-release-build=yes  \
             --enable-python=system      \
             --with-jdk-home=/opt/jdk    \
             --with-system-boost         \
             --with-system-clucene       \
             --with-system-curl          \
             --with-system-epoxy         \
             --with-system-expat         \
             --with-system-glm           \
             --with-system-gpgmepp       \
             --with-system-graphite      \
             --with-system-harfbuzz      \
             --with-system-icu           \
             --with-system-jpeg          \
             --with-system-lcms2         \
             --with-system-libatomic_ops \
             --with-system-libpng        \
             --with-system-libxml        \
             --with-system-nss           \
             --with-system-odbc          \
             --with-system-openldap      \
             --with-system-openssl       \
             --with-system-poppler       \
             --disable-postgresql-sdbc    \
             --with-system-redland       \
             --with-system-libtiff       \
             --with-system-libwebp       \
             --with-system-zlib
make build
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make distro-pack-install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
update-desktop-database
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd