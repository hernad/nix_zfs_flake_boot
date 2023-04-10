#!/bin/bash

installDisk=/dev/nvme0n1

# first disk partition NixOS
diskPart=4

# SWAP = 8GB
INST_PARTSIZE_SWAP=8


P_EFI=$diskPart
diskPart=$((diskPart+1))
P_BOOT=$diskPart

diskPart=$((diskPart+1))
P_ROOT=$diskPart

diskPart=$((diskPart+1))
P_SWAP=$diskPart


diskPart=$((diskPart+1))
P_BIOS=$diskPart

echo installDisk=$installDisk
echo "SWAP SIZE (GB)=$INST_PARTSIZE_SWAP"
echo P_EFI=$P_EFI
echo P_BOOT=$P_BOOT
echo P_ROOT=$P_ROOT
echo P_SWAP=$P_SWAP