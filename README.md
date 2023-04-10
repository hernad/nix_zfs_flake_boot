# NixOS laptop 

Based on:

   https://github.com/Hoverbear-Consulting/flake

## Create recovery image

<pre>
    nix build .#nixosConfigurations.x86_64IsoImage.config.system.build.isoImage --out-link isoImage
    ARCHITECT_USB=/dev/null
    sudo umount /dev/sda*
    #umount $ARCHITECT_USB
    #sudo cp -vi isoImage/iso/*.iso $ARCHITECT_USB
    sudo dd if=isoImage/iso/nixos-23.05.20230319.60c1d71-x86_64-linux.iso of=/dev/sda bs=4M conv=fsync
</pre>

## ssh login from developer workstation to live ISO

<pre>
   sudo passwd root
   ssh root@IP_ADDRESS 
</pre>

## setup partitions, zpools, mounts


1. part.sh: define install disk, first NixOS partition:


<pre>
    nix flake clone github:hernad/nix_zfs_flake_boot --dest flake
    cd flake

    # 1. podesiti scripts/part.sh
    ## 1.1 installDisk=/dev/nvme0n1
    ## first disk partition NixOS
    #  1.2 diskPart=4

    # 2. podesiti hosts/yoga15/default.nix
    # partitionScheme
</pre>

2. create partitions, zpool, mount zfs, vfat /mnt, /mnt/boot: 

<pre>
    bash scripts/part_create.sh
    bash scripts/zpool_create.sh
</pre>

## install nixos on /mnt

<pre>
    nixos-install --flake .#yoga15
    umount -Rl /mnt
    zpool export -a
</pre>

## Update system inside NixOS

<pre>
    nix flake clone github:hernad/nix_zfs_flake_boot --dest nix_zfs_flake_boot
    cd nix_zfs_flake_boot
    sudo nixos-rebuild --flake .#yoga15
</pre>


