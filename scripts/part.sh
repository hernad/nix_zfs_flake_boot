#!/bin/bash

# first disk partition NixOS
diskPart=4
installDisk=/dev/nvme0n1
# SWAP = 8GB
INST_PARTSIZE_SWAP=8


P_EFI=$diskPart
diskPart=$((diskPart+1))
P_BOOT=$diskPart

diskPart=$((diskPart+1))
P_ROOT=$diskPart

diskPart=$((diskPart+1))
P_SWAP=$diskPart


#diskPart=$((diskPart+1))
#P_BIOS=$diskPart