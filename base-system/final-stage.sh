#!/bin/bash

set -e
set +h

cd /sources/
. ./build-properties

if ! grep "root-and-admin-passwords" /sources/build-log &> /dev/null
then

echo "Setting the password for root :"
usermod --password $(echo $1 | openssl passwd -1 -stdin) root

echo "Setting the password for $USERNAME :"
usermod --password $(echo $2 | openssl passwd -1 -stdin) $USERNAME

echo "root-and-admin-passwords" >> /sources/build-log

fi
