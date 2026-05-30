#!/bin/bash

set -e
set +h

mkdir -pv ~/sources
cp wget-list ~/sources
pushd ~/sources
wget -nc -i wget-list
wget -nc https://github.com/dylanaraps/neofetch/archive/refs/tags/7.1.0.tar.gz -O neofetch-7.1.0.tar.gz
popd
