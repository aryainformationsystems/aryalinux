#!/bin/bash

set -e

. /sources/build-properties

# Building additional temp tools
for script in /sources/additional-temp-tools/*
do
	bash $script
done

# Building the final system
for script in /sources/final-system/*
do
	bash $script
done
