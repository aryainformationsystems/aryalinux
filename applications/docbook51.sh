#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libxml2
#REQ:sgml-common
#REQ:unzip


cd $SOURCE_DIR

NAME=docbook51
VERSION=5.
URL=https://docbook.org/xml/5.1/docbook-v5.1-os.zip
SECTION="Extensible Markup Language (XML)"
DESCRIPTION="The DocBook XML Schemas-5.1 package contains schema files and Schematron rules for verification of XML data files against the DocBook rule set. These are useful for structuring books and software documentation to a standard allowing you to utilize transformations already written for that standard."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://docbook.org/xml/5.1/docbook-v5.1-os.zip


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
install -vdm755 /usr/share/xml/docbook/schema/{rng,sch}/5.1         &&
install -m644   schemas/rng/* /usr/share/xml/docbook/schema/rng/5.1 &&
install -m644   schemas/sch/* /usr/share/xml/docbook/schema/sch/5.1 &&
install -m755   tools/db4-entities.pl /usr/bin                      &&
install -vdm755 /usr/share/xml/docbook/stylesheet/docbook5          &&
install -m644   tools/db4-upgrade.xsl \
                /usr/share/xml/docbook/stylesheet/docbook5
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
if [ ! -e /etc/xml/docbook-5.1 ]; then
  xmlcatalog --noout --create /etc/xml/docbook-5.1
fi &&

xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/rng/docbook.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbook.rng" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/rng/docbook.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbook.rng" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/rng/docbookxi.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbookxi.rng" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/rng/docbookxi.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbookxi.rng" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/rnc/docbook.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbook.rnc" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/rng/docbook.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbook.rnc" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/rnc/docbookxi.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbookxi.rnc" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/rng/docbookxi.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbookxi.rnc" \
  /etc/xml/docbook-5.1 &&

xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/sch/docbook.sch" \
  "file:///usr/share/xml/docbook/schema/sch/5.1/docbook.sch" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/sch/docbook.sch" \
  "file:///usr/share/xml/docbook/schema/sch/5.1/docbook.sch" \
  /etc/xml/docbook-5.1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
xmlcatalog --noout --create /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&

xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/schemas/rng/docbook.schemas/rng" \
  "docbook.schemas/rng" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/schemas/rng/docbook.schemas/rng" \
  "docbook.schemas/rng" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/schemas/rng/docbookxi.schemas/rng" \
  "docbookxi.schemas/rng" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/schemas/rng/docbookxi.schemas/rng" \
  "docbookxi.schemas/rng" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/schemas/rng/docbook.rnc" \
  "docbook.rnc" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/schemas/rng/docbook.rnc" \
  "docbook.rnc" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/schemas/rng/docbookxi.rnc" \
  "docbookxi.rnc" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/schemas/rng/docbookxi.rnc" \
  "docbookxi.rnc" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml
xmlcatalog --noout --create /usr/share/xml/docbook/schema/sch/5.1/catalog.xml &&

xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/schemas/sch/docbook.schemas/sch" \
  "docbook.schemas/sch" /usr/share/xml/docbook/schema/sch/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/schemas/sch/docbook.schemas/sch" \
  "docbook.schemas/sch" /usr/share/xml/docbook/schema/sch/5.1/catalog.xml
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
if [ ! -e /etc/xml/catalog ]; then
  xmlcatalog --noout --create /etc/xml/catalog
fi &&
xmlcatalog --noout --add "delegatePublic" \
  "-//OASIS//DTD DocBook XML 5.1//EN" \
  "file:///usr/share/xml/docbook/schema/dtd/5.1/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateSystem" \
  "http://docbook.org/xml/5.1/dtd/" \
  "file:///usr/share/xml/docbook/schema/dtd/5.1/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.1/dtd/" \
  "file:///usr/share/xml/docbook/schema/dtd/5.1/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.1/rng/"  \
  "file:///usr/share/xml/docbook/schema/rng/5.1/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.1/sch/"  \
  "file:///usr/share/xml/docbook/schema/sch/5.1/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.1/xsd/"  \
  "file:///usr/share/xml/docbook/schema/xsd/5.1/catalog.xml" \
  /etc/xml/catalog
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd