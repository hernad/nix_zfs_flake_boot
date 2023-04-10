#!/bin/bash

if [ ! -f ./scripts/part.sh ]; then
   echo ./scripts/part.sh not exists
   exit 1
fi

source ./scripts/part.sh

umount /mnt/boot/efis/${installDisk##*/}p${P_EFI}
rm -rf /mnt/*

echo zpool create bpool on ${installDisk}p${P_BOOT}
zpool create -f \
    -o compatibility=grub2 \
    -o ashift=12 \
    -o autotrim=on \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=lz4 \
    -O devices=off \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=/boot \
    -R /mnt \
    bpool \
    ${installDisk}p${P_BOOT}

echo zpool create rpool on ${installDisk}p${P_ROOT}
zpool create -f \
    -o ashift=12 \
    -o autotrim=on \
    -R /mnt \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=zstd \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=/ \
    rpool \
    ${installDisk}p${P_ROOT}

zfs create \
 -o canmount=off \
 -o mountpoint=none \
 rpool/nixos

zfs create -o mountpoint=legacy     rpool/nixos/root
mount -t zfs rpool/nixos/root /mnt/
zfs create -o mountpoint=legacy rpool/nixos/home
mkdir /mnt/home
mount -t zfs  rpool/nixos/home /mnt/home
zfs create -o mountpoint=legacy rpool/nixos/var
zfs create -o mountpoint=legacy rpool/nixos/var/log
zfs create -o mountpoint=legacy rpool/nixos/nix

zfs create -o mountpoint=none bpool/nixos
zfs create -o mountpoint=legacy bpool/nixos/root

mkdir /mnt/boot
mount -t zfs bpool/nixos/root /mnt/boot
zfs create -o mountpoint=legacy rpool/nixos/empty
zfs snapshot rpool/nixos/empty@start

mkfs.vfat -n EFI ${installDisk}p${P_EFI}
mkdir -p /mnt/boot/efis/${installDisk##*/}p${P_EFI}
mount -t vfat ${installDisk}p${P_EFI} /mnt/boot/efis/${installDisk##*/}p${P_EFI}

echo =============== results ================================
zpool list -v

mount | grep vfat

zfs list

