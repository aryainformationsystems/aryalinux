#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gconf
#REQ:gtk2
#REQ:gtk3
#REQ:frameworks5
#REQ:libpwquality
#REQ:libxkbcommon
#REQ:mesa
#REQ:wayland
#REQ:networkmanager
#REQ:pipewire
#REQ:pulseaudio
#REQ:qca
#REQ:sassc
#REQ:taglib
#REQ:xcb-util-cursor
#REQ:fftw
#REQ:gsettings-desktop-schemas
#REQ:libdbusmenu-qt
#REQ:libcanberra
#REQ:libinput
#REQ:linux-pam
#REQ:lm_sensors
#REQ:oxygen-icons5
#REQ:pciutils
#REQ:smartmontools

#REQ:kdecoration
#REQ:libkscreen
#REQ:libksysguard
#REQ:breeze
#REQ:breeze-gtk
#REQ:kscreenlocker
#REQ:oxygen
#REQ:kinfocenter
#REQ:ksysguard
#REQ:kwayland-server
#REQ:kwin
#REQ:plasma-workspace
#REQ:plasma-disks
#REQ:bluedevil
#REQ:kde-gtk-config
#REQ:khotkeys
#REQ:kmenuedit
#REQ:kscreen
#REQ:kwallet-pam
#REQ:kwayland-integration
#REQ:kwrited
#REQ:milou
#REQ:plasma-nm
#REQ:plasma-pa
#REQ:plasma-workspace-wallpapers
#REQ:polkit-kde-agent-1
#REQ:powerdevil
#REQ:plasma-desktop
#REQ:kdeplasma-addons
#REQ:kgamma5
#REQ:ksshaskpass
#REQ:sddm-kcm
#REQ:discover
#REQ:kactivitymanagerd
#REQ:plasma-integration
#REQ:plasma-tests
#REQ:xdg-desktop-portal-kde
#REQ:drkonqi
#REQ:plasma-vault
#REQ:plasma-browser-integration
#REQ:kde-cli-tools
#REQ:systemsettings
#REQ:plasma-thunderbolt
#REQ:plasma-firewall
#REQ:plasma-systemmonitor
#REQ:qqc2-breeze-style

cd $SOURCE_DIR

NAME=plasma-all
VERSION=5.21.5
SECTION="KDE Plasma 5"


mkdir -pv $NAME
pushd $NAME

sudo tee /etc/pam.d/kde << "EOF"
# Begin /etc/pam.d/kde

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     include        system-auth

account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/kde
EOF

sudo tee /etc/pam.d/kde-np << "EOF"
# Begin /etc/pam.d/kde-np

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     required       pam_permit.so

account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/kde-np
EOF

sudo tee /etc/pam.d/kscreensaver << "EOF"
# Begin /etc/pam.d/kscreensaver

auth    include system-auth
account include system-account

# End /etc/pam.d/kscreensaver
EOF


register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd