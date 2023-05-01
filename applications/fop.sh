#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:apache-ant


cd $SOURCE_DIR

NAME=fop
VERSION=2.
URL=https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.8-src.tar.gz
SECTION="PostScript"
DESCRIPTION="The FOP (Formatting Objects Processor) package contains a print formatter driven by XSL formatting objects (XSL-FO). It is a Java application that reads a formatting object tree and renders the resulting pages to a specified output. Output formats currently supported include PDF, PCL, PostScript, SVG, XML (area tree representation), print, AWT, MIF and ASCII text. The primary output target is PDF."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.8-src.tar.gz
wget -nc https://archive.apache.org/dist/pdfbox/2.0.27/pdfbox-2.0.27.jar
wget -nc https://archive.apache.org/dist/pdfbox/2.0.27/fontbox-2.0.27.jar
wget -nc https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
wget -nc https://downloads.sourceforge.net/offo/2.2/offo-hyphenation.zip


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


unzip ../offo-hyphenation.zip &&
cp offo-hyphenation/hyph/* fop/hyph &&
rm -rf offo-hyphenation
tar -xf ../apache-maven-3.8.6-bin.tar.gz -C /tmp
sed -i '\@</javad@i\
<arg value="-Xdoclint:none"/>\
<arg value="--allow-script-in-comments"/>\
<arg value="--ignore-source-errors"/>' \
    fop/build.xml
cp ../{pdf,font}box-2.0.27.jar fop/lib
cd fop &&

LC_ALL=en_US.UTF-8                     \
PATH=$PATH:/tmp/apache-maven-3.8.6/bin \
ant all javadocs &&

mv build/javadocs .
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -d -m755 -o root -g root          /opt/fop-2.8 &&
cp -vR build conf examples fop* javadocs lib /opt/fop-2.8 &&
chmod a+x /opt/fop-2.8/fop                                &&
ln -v -sfn fop-2.8 /opt/fop
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

rm -rf /tmp/apache-maven-3.8.6
cat > ~/.foprc << "EOF"
FOP_OPTS="-Xmx<RAM_Installed>m"
FOP_HOME="/opt/fop"
EOF
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/profile.d/fop.sh << "EOF"
# Begin /etc/profile.d/fop.sh

pathappend /opt/fop

# End /etc/profile.d/fop.sh
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd