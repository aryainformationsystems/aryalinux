#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:boost
#REQ:extra-cmake-modules
#REQ:docbook
#REQ:docbook-xsl
#REQ:giflib
#REQ:libepoxy
#REQ:libgcrypt
#REQ:libical
#REQ:libjpeg
#REQ:libpng
#REQ:libxslt
#REQ:lmdb
#REQ:qrencode
#REQ:phonon
#REQ:plasma-wayland-protocols
#REQ:shared-mime-info
#REQ:perl-modules#perl-uri
#REQ:wget
#REQ:aspell
#REQ:avahi
#REQ:libdbusmenu-qt
#REQ:networkmanager
#REQ:polkit-qt
#REQ:kf5-intro
#REQ:noto-fonts
#REQ:oxygen-fonts
#REQ:bluez
#REQ:modemmanager
#REQ:jasper
#REQ:mitkrb
#REQ:udisks2
#REQ:upower
#REQ:media-player-info

#REQ:attica
#REQ:kapidox
#REQ:karchive
#REQ:kcodecs
#REQ:kconfig
#REQ:kcoreaddons
#REQ:kdbusaddons
#REQ:kdnssd
#REQ:kguiaddons
#REQ:ki18n
#REQ:kidletime
#REQ:kimageformats
#REQ:kitemmodels
#REQ:kitemviews
#REQ:kplotting
#REQ:kwidgetsaddons
#REQ:kwindowsystem
#REQ:networkmanager-qt
#REQ:solid
#REQ:sonnet
#REQ:threadweaver
#REQ:kauth
#REQ:kcompletion
#REQ:kcrash
#REQ:kdoctools
#REQ:kpty
#REQ:kunitconversion
#REQ:kconfigwidgets
#REQ:kservice
#REQ:kglobalaccel
#REQ:kpackage
#REQ:kdesu
#REQ:kemoticons
#REQ:kiconthemes
#REQ:kjobwidgets
#REQ:knotifications
#REQ:ktextwidgets
#REQ:kxmlgui
#REQ:kbookmarks
#REQ:kwallet
#REQ:kded
#REQ:kio
#REQ:kdeclarative
#REQ:kcmutils
#REQ:kirigami
#REQ:knewstuff
#REQ:frameworkintegration
#REQ:kinit
#REQ:knotifyconfig
#REQ:kparts
#REQ:kactivities
#REQ:syntax-highlighting
#REQ:ktexteditor
#REQ:kwayland
#REQ:plasma-framework
#REQ:kpeople
#REQ:kxmlrpcclient
#REQ:bluez-qt
#REQ:kfilemetadata
#REQ:baloo
#REQ:kactivities-stats
#REQ:krunner
#REQ:prison
#REQ:qqc2-desktop-style
#REQ:kjs
#REQ:kdesignerplugin
#REQ:kdelibs4support
#REQ:khtml
#REQ:kjsembed
#REQ:kmediaplayer
#REQ:kross
#REQ:kholidays
#REQ:purpose
#REQ:kcalendarcore
#REQ:kcontacts
#REQ:kquickcharts
#REQ:kdav

NAME=frameworks5
VERSION=5.82
SECTION="KDE Plasma 5"

cd $SOURCE_DIR


register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
