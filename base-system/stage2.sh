#!/bin/bash

set -e

. $LFS/sources/build-properties

# Compiling a Cross-Toolchain
for script in $LFS/sources/cross-toolchain/*.sh
do

bash $script

done

# Cross Compiling Temporary Tools
for script in $LFS/sources/temp-tools/*.sh
do

bash $script

done
