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

echo P_EFI=$P_EFI
echo P_BOOT=$P_BOOT
echo P_ROOT=$P_ROOT
echo P_SWAP=$P_SWAP


sgdisk -n${P_EFI}:0:+1G -t${P_EFI}:EF00 $installDisk

sgdisk -n${P_BOOT}:0:+4G -t${P_BOOT}:BE00 $installDisk

sgdisk -n${P_SWAP}:0:+${INST_PARTSIZE_SWAP}G -t${P_SWAP}:8200 $installDisk

sgdisk -n${P_ROOT}:0:0 -t${P_ROOT}:BF00 $installDisk

#sgdisk -a1 -n${P_BIOS}:24K:+1000K -t${P_BIOS}:EF02 $installDisk

sync && udevadm settle && sleep 3

cryptsetup open --type plain --key-file /dev/random ${installDisk}p${P_SWAP} ${installDisk##*/}p${P_SWAP}
mkswap /dev/mapper/${installDisk##*/}p${P_SWAP}
swapon /dev/mapper/${installDisk##*/}p${P_SWAP}
