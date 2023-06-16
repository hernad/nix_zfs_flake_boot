# NixOS laptop 

Based on:

   https://github.com/Hoverbear-Consulting/flake


## gnome settings

https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/

    dconf watch /


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
    sudo nixos-rebuild --flake .#yoga15 switch
</pre>


## Update packages verzija

<pre>
    sudo nix flake update
    git commit -am "flake.lock" update
    scripts/rebuild.sh lenovo16
</pre>

## trenutno stanje

<pre>
❯ nix flake metadata

warning: Git tree '/home/hernad/nix_zfs_flake_boot' is dirty
Resolved URL:  git+file:///home/hernad/nix_zfs_flake_boot
Locked URL:    git+file:///home/hernad/nix_zfs_flake_boot
Path:          /nix/store/rysif6lfyy6l0nc578gfs3rjh54kpf9w-source
Last modified: 2023-06-16 11:17:07
Inputs:
├───home-manager: github:nix-community/home-manager/ea2f17615e31783ace1271a3325e9cac27c3b4d8
│   └───nixpkgs follows input 'nixpkgs'
├───nixpkgs: github:nixos/nixpkgs/0eeebd64de89e4163f4d3cf34ffe925a5cf67a05
└───nur: github:nix-community/NUR/6f1156df74875c31b154b584867a0c57196cdb9b
</pre>


# Show kernel config for this lenovo16 host

https://lunnova.dev/articles/nixos-find-kernel-config/

<pre>
nix-shell -p nixVersions.nix_2_15 --run "bat $(nix build --print-out-paths --no-link .#nixosConfigurations.lenovo16.config.boot.kernelPackages.kernel.configfile)"
</pre>


