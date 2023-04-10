# Nix laptop 

Based on:

   https://github.com/Hoverbear-Consulting/flake


## Create recovery image

    nix build .#nixosConfigurations.x86_64IsoImage.config.system.build.isoImage --out-link isoImage
    ARCHITECT_USB=/dev/null
    sudo umount /dev/sda*
    #umount $ARCHITECT_USB
    #sudo cp -vi isoImage/iso/*.iso $ARCHITECT_USB
    sudo dd if=isoImage/iso/nixos-23.05.20230319.60c1d71-x86_64-linux.iso of=/dev/sda bs=4M conv=fsync


## ssh to live image

   sudo passwd root
   ssh root@IP_ADDRESS 

## setup partitions, zpools, mounts


1.. part.sh: define install disk, first NixOS partition:

    nix flake clone github:hernad/nix_zfs_flake_boot --dest flake
    cd flake

    # 1. podesiti scripts/part.sh
    ## 1.1 installDisk=/dev/nvme0n1
    ## first disk partition NixOS
    #  1.2 diskPart=4

    # 2. podesiti hosts/yoga15/default.nix
    # partitionScheme


2. create partitions, zpool, mount zfs, vfat /mnt, /mnt/boot: 

    bash scripts/part_create.sh
    bash scripts/zpool_create.sh


## install nixos on /mnt

    nixos-install --flake .#yoga15
    umount -Rl /mnt
    zpool export -a



