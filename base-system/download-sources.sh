#!/bin/bash

set -e
set +h

mkdir -pv ~/sources
cp wget-list ~/sources
pushd ~/sources
wget -nc -i wget-list
popd
