#!/bin/bash

set -e

if [ -f ./build-properties ]; then
	. ./build-properties
else
	. /sources/build-properties
fi

type=$(sudo fdisk -l $DEV_NAME | grep "Disklabel type" | tr -s ' ' | rev | cut -d ' ' -f1 | rev)

status=0

# Bail out if have boot in UEFI mode but no GPT partition table
if [ -d /sys/lib/firmware ] && [ $type == "msdos" ]; then
	echo "Cannot install bootloader. Please boot in legacy mode."
	exit 1
fi

# Bail out if have boot in legacy mode and no msdos partition table
if [ ! -d /sys/lib/firmware ] && [ $type == "gpt" ]; then
	echo "Cannot install bootloader. Please boot in EFI mode."
fi

efipart=$(sudo fdisk -l $DEV_NAME | grep "EFI System" | tr -s ' ' | cut -d ' ' -f1)

# Bail out if have boot in UEFI mode and have GPT partition table but no EFI partition
if [ -d /sys/lib/firmware ] && [ $type == "gpt" ] && [ "x$efipart" == "x" ]; then
	echo "Cannot install bootloader. No EFI Partition found."
	exit 1
fi

