#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:autoconf213
#REQ:cbindgen
#REQ:dbus-glib
#REQ:gtk3
#REQ:libnotify
#REQ:llvm
#REQ:nodejs
#REQ:pulseaudio
#REQ:alsa-lib
#REQ:python3
#REQ:sqlite
#REQ:startup-notification
#REQ:unzip
#REQ:yasm
#REQ:zip
#REQ:icu
#REQ:libevent
#REQ:libvpx
#REQ:libwebp
#REQ:nasm
#REQ:nss


cd $SOURCE_DIR

NAME=firefox
VERSION=102.10.
URL=https://archive.mozilla.org/pub/firefox/releases/102.10.0esr/source/firefox-102.10.0esr.source.tar.xz
SECTION="Graphical Web Browsers"
DESCRIPTION="Firefox is a stand-alone browser based on the Mozilla codebase."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://archive.mozilla.org/pub/firefox/releases/102.10.0esr/source/firefox-102.10.0esr.source.tar.xz
wget -nc https://raw.githubusercontent.com/aryainformationsystems/patches/1.0/firefox-102.10.0-upstream_fixes-1.patch
wget -nc https://raw.githubusercontent.com/aryainformationsystems/patches/1.0/firefox-102.10.0-ffmpeg_6-1.patch


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


cat > mozconfig << "EOF"
# If you have a multicore machine, all cores will be used by default.

# If you have installed (or will install) wireless-tools, and you wish
# to use geolocation web services, comment out this line
ac_add_options --disable-necko-wifi

# API Keys for geolocation APIs - necko-wifi (above) is required for MLS
# Uncomment the following line if you wish to use Mozilla Location Service
#ac_add_options --with-mozilla-api-keyfile=$PWD/mozilla-key

# Uncomment the following line if you wish to use Google's geolocation API
# (needed for use with saved maps with Google Maps)
#ac_add_options --with-google-location-service-api-keyfile=$PWD/google-key

# startup-notification is required since firefox-78

# Uncomment the following option if you have not installed PulseAudio and
# want to use alsa instead
#ac_add_options --enable-audio-backends=alsa

# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --with-system-icu
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-webp

# Unlike with thunderbird, although using the gold linker can
# save four megabytes in the installed file it does not make
# the build faster.

# libdavid (av1 decoder) requires nasm. Uncomment this if nasm
# has not been installed. Do not uncomment this if you have
# ffmpeg installed.
#ac_add_options --disable-av1

# You cannot distribute the binary if you do this
ac_add_options --enable-official-branding

# Stripping is now enabled by default.
# Uncomment these lines if you need to run a debugger:
#ac_add_options --disable-strip
#ac_add_options --disable-install-strip

# Disabling debug symbols makes the build much smaller and a little
# faster. Comment this if you need to run a debugger. Note: This is
# required for compilation on i686.
ac_add_options --disable-debug-symbols

# The elf-hack is reported to cause failed installs (after successful builds)
# on some machines. It is supposed to improve startup time and it shrinks
# libxul.so by a few MB - comment this if you know your machine is not affected.
ac_add_options --disable-elf-hack

# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=browser
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
# enabling the tests will use a lot more space and significantly
# increase the build time, for no obvious benefit.
ac_add_options --disable-tests

# The default level of optimization again produces a working build with gcc.
ac_add_options --enable-optimize

ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman

ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib

# Using sandboxed wasm libraries has been moved to all builds instead
# of only mozilla automation builds. It requires extra llvm packages
# and was reported to seriously slow the build. Disable it.
ac_add_options --without-wasm-sandboxed-libraries

# The following option unsets Telemetry Reporting. With the Addons Fiasco,
# Mozilla was found to be collecting user's data, including saved passwords and
# web form data, without users consent. Mozilla was also found shipping updates
# to systems without the user's knowledge or permission.
# As a result of this, use the following command to permanently disable
# telemetry reporting in Firefox.
unset MOZ_TELEMETRY_REPORTING

mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/firefox-build-dir
EOF
echo "AIzaSyDxKL42zsPjbke5O8_rPVpVrLrJ8aeE9rQ" > google-key
echo "613364a7-9418-4c86-bcee-57e32fd70c23" > mozilla-key
mountpoint -q /dev/shm || mount -t tmpfs devshm /dev/shm
patch -Np1 -i ../firefox-102.10.0-upstream_fixes-1.patch
patch -Np1 -i ../firefox-102.10.0-ffmpeg_6-1.patch
export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=none &&
export MOZBUILD_STATE_PATH=${PWD}/mozbuild          &&
./mach configure                                    &&
./mach build
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=none ./mach install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

unset MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE MOZBUILD_STATE_PATH
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mkdir -pv /usr/share/applications &&
mkdir -pv /usr/share/pixmaps      &&

MIMETYPE="text/xml;text/mml;text/html;"                            &&
MIMETYPE+="application/xhtml+xml;application/vnd.mozilla.xul+xml;" &&
MIMETYPE+="x-scheme-handler/http;x-scheme-handler/https"           &&

cat > /usr/share/applications/firefox.desktop << EOF &&
[Desktop Entry]
Encoding=UTF-8
Name=Firefox Web Browser
Comment=Browse the World Wide Web
GenericName=Web Browser
Exec=firefox %u
Terminal=false
Type=Application
Icon=firefox
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=$MIMETYPE
StartupNotify=true
EOF

unset MIMETYPE &&

ln -sfv /usr/lib/firefox/browser/chrome/icons/default/default128.png \
        /usr/share/pixmaps/firefox.png
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd