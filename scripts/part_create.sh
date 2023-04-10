#!/bin/bash

if [ ! -f ./scripts/part.sh ]; then
   echo ./scripts/part.sh not exists
   exit 1
fi

source ./scripts/part.sh


sgdisk -n${P_EFI}:0:+1G -t${P_EFI}:EF00 $installDisk

sgdisk -n${P_BOOT}:0:+4G -t${P_BOOT}:BE00 $installDisk

sgdisk -n${P_SWAP}:0:+${INST_PARTSIZE_SWAP}G -t${P_SWAP}:8200 $installDisk

sgdisk -n${P_ROOT}:0:0 -t${P_ROOT}:BF00 $installDisk

#sgdisk -a1 -n${P_BIOS}:24K:+1000K -t${P_BIOS}:EF02 $installDisk

sync && udevadm settle && sleep 3

cryptsetup open --type plain --key-file /dev/random ${installDisk}p${P_SWAP} ${installDisk##*/}p${P_SWAP}
mkswap /dev/mapper/${installDisk##*/}p${P_SWAP}
swapon /dev/mapper/${installDisk##*/}p${P_SWAP}
