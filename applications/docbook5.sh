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

NAME=docbook5
VERSION=5.0
URL=https://docbook.org/xml/5.0/docbook-5.0.zip
SECTION="Extensible Markup Language (XML)"
DESCRIPTION="The DocBook XML DTD and Schemas-5.0 package contains document type definitions and schemas for verification of XML data files against the DocBook rule set. These are useful for structuring books and software documentation to a standard allowing you to utilize transformations already written for that standard. In addition to providing a DTD, version 5 introduced the RelaxNG schema and Schematron rules, and is incompatible with previous versions of DocBook XML."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://docbook.org/xml/5.0/docbook-5.0.zip


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
install -vdm755 /usr/share/xml/docbook/schema/{dtd,rng,sch,xsd}/5.0 &&
install -vm644  dtd/* /usr/share/xml/docbook/schema/dtd/5.0         &&
install -vm644  rng/* /usr/share/xml/docbook/schema/rng/5.0         &&
install -vm644  sch/* /usr/share/xml/docbook/schema/sch/5.0         &&
install -vm644  xsd/* /usr/share/xml/docbook/schema/xsd/5.0
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
if [ ! -e /etc/xml/docbook-5.0 ]; then
    xmlcatalog --noout --create /etc/xml/docbook-5.0
fi &&

xmlcatalog --noout --add "public" \
  "-//OASIS//DTD DocBook XML 5.0//EN" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/docbook.dtd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "system" \
  "http://www.oasis-open.org/docbook/xml/5.0/dtd/docbook.dtd" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/docbook.dtd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "system" \
  "http://docbook.org/xml/5.0/dtd/docbook.dtd" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/docbook.dtd" \
  /etc/xml/docbook-5.0 &&

xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rng/docbook.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbook.rng" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbook.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbook.rng" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rng/docbookxi.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbookxi.rng" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbookxi.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbookxi.rng" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rnc/docbook.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbook.rnc" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbook.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbook.rnc" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rnc/docbookxi.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbookxi.rnc" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbookxi.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbookxi.rnc" \
  /etc/xml/docbook-5.0 &&

xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/docbook.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/docbook.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/docbook.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/docbook.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/docbookxi.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/docbookxi.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/docbookxi.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/docbookxi.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/xi.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/xi.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/xi.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/xi.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/xlink.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/xlink.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/xlink.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/xlink.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/xml.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/xml.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/xml.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/xml.xsd" \
  /etc/xml/docbook-5.0 &&

xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/sch/docbook.sch" \
  "file:///usr/share/xml/docbook/schema/sch/5.0/docbook.sch" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/sch/docbook.sch" \
  "file:///usr/share/xml/docbook/schema/sch/5.0/docbook.sch" \
  /etc/xml/docbook-5.0
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
xmlcatalog --noout --create /usr/share/xml/docbook/schema/dtd/5.0/catalog.xml &&

xmlcatalog --noout --add "public" \
  "-//OASIS//DTD DocBook XML 5.0//EN" \
  "docbook.dtd" /usr/share/xml/docbook/schema/dtd/5.0/catalog.xml &&
xmlcatalog --noout --add "system" \
  "http://www.oasis-open.org/docbook/xml/5.0/dtd/docbook.dtd" \
  "docbook.dtd" /usr/share/xml/docbook/schema/dtd/5.0/catalog.xml &&

xmlcatalog --noout --create /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbook.rng" \
  "docbook.rng" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rng/docbook.rng" \
  "docbook.rng" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbookxi.rng" \
  "docbookxi.rng" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rng/docbookxi.rng" \
  "docbookxi.rng" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbook.rnc" \
  "docbook.rnc" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rng/docbook.rnc" \
  "docbook.rnc" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbookxi.rnc" \
  "docbookxi.rnc" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rng/docbookxi.rnc" \
  "docbookxi.rnc" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&

xmlcatalog --noout --create /usr/share/xml/docbook/schema/sch/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/sch/docbook.sch" \
  "docbook.sch" /usr/share/xml/docbook/schema/sch/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/sch/docbook.sch" \
  "docbook.sch" /usr/share/xml/docbook/schema/sch/5.0/catalog.xml &&

xmlcatalog --noout --create /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/docbook.xsd" \
  "docbook.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/docbook.xsd" \
  "docbook.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/docbookxi.xsd" \
  "docbookxi.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/docbookxi.xsd" \
  "docbookxi.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/xlink.xsd" \
  "xlink.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
   "http://www.oasis-open.org/docbook/xml/5.0/xsd/xlink.xsd" \
   "xlink.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
   "http://docbook.org/xml/5.0/xsd/xml.xsd" \
   "xml.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
   "http://www.oasis-open.org/docbook/xml/5.0/xsd/xml.xsd" \
   "xml.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml
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
  "-//OASIS//DTD DocBook XML 5.0//EN" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateSystem" \
  "http://docbook.org/xml/5.0/dtd/" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.0/dtd/" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.0/rng/"  \
  "file:///usr/share/xml/docbook/schema/rng/5.0/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.0/sch/"  \
  "file:///usr/share/xml/docbook/schema/sch/5.0/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.0/xsd/"  \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/catalog.xml" \
  /etc/xml/catalog
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd