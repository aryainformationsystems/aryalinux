#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gobject-introspection
#REQ:desktop-file-utils
#REQ:shared-mime-info
#REQ:libxml2
#REQ:libxslt
#REQ:glib2
#REQ:libidl
#REQ:dbus
#REQ:dbus-glib
#REQ:polkit
#REQ:popt
#REQ:libgcrypt
#REQ:gtk2
#REQ:libcanberra
#REQ:libart
#REQ:libglade
#REQ:libtasn1
#REQ:libxklavier
#REQ:libsoup
#REQ:icon-naming-utils
#REQ:libunique
#REQ:libwnck
#REQ:librsvg
#REQ:upower
#REQ:libtasn1
#REQ:xmlto
#REQ:gtk-doc
#REQ:rarian
#REQ:dconf
#REQ:libsecret
#REQ:gnome-keyring
#REQ:libnotify
#REQ:libwnck2
#REQ:zenity
#REQ:yelp
#REQ:xdg-utils
#REQ:xdg-user-dirs
#REQ:python-modules#docutils
#REQ:python-modules#pygobject2
#REQ:python-modules#pygobject3
#REQ:libpeas
#REQ:gtksourceview
#REQ:poppler
#REQ:libgtop
#REQ:gtkmm2
#REQ:gtkmm3
#REQ:glibmm
#REQ:gnome-keyring
#REQ:mate-common
#REQ:mate-desktop
#REQ:libmatekbd
#REQ:libmatewnck
#REQ:libmateweather
#REQ:mate-icon-theme
#REQ:caja
#REQ:marco
#REQ:mate-settings-daemon
#REQ:mate-session-manager
#REQ:mate-menus
#REQ:mate-panel
#REQ:mate-control-center
#REQ:lightdm
#REQ:plymouth
#REQ:mate-screensaver
#REQ:vte2
#REQ:vte
#REQ:mate-terminal
#REQ:gvfs
#REQ:caja
#REQ:caja-extensions
#REQ:caja-dropbox
#REQ:pluma
#REQ:gthumb
#REQ:engrampa
#REQ:epdfview
#REQ:udisks2
#REQ:mate-utils
#REQ:murrine-gtk-engine
#REQ:gnome-themes-standard
#REQ:adwaita-icon-theme
#REQ:mate-system-monitor
#REQ:mate-power-manager
#REQ:marco
#REQ:mozo
#REQ:mate-backgrounds
#REQ:libmatemixer
#REQ:mate-media
#REQ:wireless_tools
#REQ:wpa_supplicant
#REQ:networkmanager
#REQ:modemmanager
#REQ:network-manager-applet
#REQ:net-tools
#REQ:usb-modeswitch
#REQ:aryalinux-wallpapers
#REQ:aryalinux-google-fonts
#REQ:aryalinux-gtk-themes
#REQ:aryalinux-icons
#REQ:blueman
#REQ:aryalinux-mate-settings
#REQ:mate-calc
#REQ:mate-notification-daemon
#REQ:mate-applets


cd $SOURCE_DIR

NAME=mate-desktop-environment
VERSION=1.23.2

SECTION="Mate Desktop"
DESCRIPTION="MATE is a desktop environment composed of free and open-source software that runs on Linux and BSD operating systems. An Argentine user of Arch Linux started the MATE project to fork and continue GNOME 2 in response to the negative reception of GNOME 3, which had replaced its traditional taskbar with GNOME Shell."


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

sudo tee /etc/gtk-2.0/gtkrc <<"EOF"
include "/usr/share/themes/Clearlooks/gtk-2.0/gtkrc"
gtk-icon-theme-name = "Flat-Remix"
EOF

sudo mkdir -pv /etc/polkit-1/localauthority/50-local.d/
sudo mkdir -pv /etc/polkit-1/rules.d/

sudo tee /etc/polkit-1/rules.d/50-org.freedesktop.NetworkManagerAndUdisks2.rules <<"EOF"
polkit.addRule(function(action, subject) {
  if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 || action.id.indexOf("org.freedesktop.udisks2.filesystem-mount") == 0) {
    return polkit.Result.YES;
  }
});
EOF

sudo mkdir -pv /usr/share/icons/default/
sudo tee /usr/share/icons/default/index.theme <<"EOF"
[Icon Theme]
Inherits=Adwaita
EOF

ccache -C
sudo ccache -C
ccache -c
sudo ccache -c

rm -rf ~/.ccache
sudo rm -rf ~/.ccache
xdg-user-dirs-update
sudo xdg-user-dirs-update

sudo tee /etc/profile.d/xdg.sh << EOF
cd ~
xdg-user-dirs-update
EOF

sudo rm -rf /etc/X11/xorg.conf.d/*

sudo tee /etc/X11/xorg.conf.d/99-synaptics-overrides.conf <<"EOF"
Section  "InputClass"
    Identifier  "touchpad overrides"
    # This makes this snippet apply to any device with the "synaptics" driver
    # assigned
    MatchDriver  "synaptics"

    ####################################
    ## The lines that you need to add ##
    # Enable left mouse button by tapping
    Option  "TapButton1"  "1"
    # Enable vertical scrolling
    Option  "VertEdgeScroll"  "1"
    # Enable right mouse button by tapping lower right corner
    Option "RBCornerButton" "3"
    ####################################

EndSection
EOF

if [ ! -f /usr/share/pixmaps/aryalinux.png ]
then
  pushd /usr/share/pixmaps/
  sudo wget http://aryalinux.info/files/aryalinux.png
  popd
fi

sudo sed -i "s@/share/backgrounds/mate/desktop/Stripes.png@/share/backgrounds/aryalinux/default-desktop-wallpaper.jpeg@g" /usr/share/glib-2.0/schemas/org.mate.background.gschema.xml
sudo sed -i "s@'Sans 10'@'Noto Sans 10'@g" /usr/share/glib-2.0/schemas/*.xml
sudo sed -i "s@'Sans 8'@'Noto Sans 8'@g" /usr/share/glib-2.0/schemas/*.xml
sudo sed -i "s@'Sans 11'@'Noto Sans 11'@g" /usr/share/glib-2.0/schemas/*.xml
sudo sed -i "s@'Sans Bold 10'@'Noto Sans 10'@g" /usr/share/glib-2.0/schemas/*.xml

sudo sed -i "s@'Monospace 10'@'Droid Sans Mono 10'@g" /usr/share/glib-2.0/schemas/*.xml
sudo sed -i "s@'Monospace 11'@'Droid Sans Mono 12'@g" /usr/share/glib-2.0/schemas/*.xml

sudo sed -i "s@'Menta'@'Arc-Dark'@g" /usr/share/glib-2.0/schemas/org.mate.marco.gschema.xml
sudo sed -i "s@'Menta'@'Arc'@g" /usr/share/glib-2.0/schemas/org.mate.interface.gschema.xml
sudo sed -i "s@'menta'@'Numix-Circle'@g" /usr/share/glib-2.0/schemas/org.mate.interface.gschema.xml

pushd /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas .
popd


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd