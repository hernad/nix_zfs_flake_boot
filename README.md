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


## setup create partition

### scripts/part.sh

1. set install disk, first NixOS partition:

    installDisk=/dev/nvme0n1
    # first disk partition NixOS
    diskPart=4

2. create partitions, zpool:

    bash scripts/part_create.sh
    bash scripts/zpool_create.sh


## nixos live

    nix flake clone github:hernad/nix_zfs_flake_boot --dest flake
    cd flake
    nixos-install --flake .#yoga15


## Install zfs root

    nix flake clone github:hernad/nix_zfs_flake_boot --dest hernad
    cd hernad

    # sudo zpool import -f bpool
    # sudo zpool import -f rpool
    # sudo bash scripts/mount_zfs.sh

    sudo nixos-install --flake .#lenovo16

    # ++++++   ne zaboraviti uraditi ovo!! ++++
    # ako se ne uradi, import zpool-ova neće biti uspješan
    sudo umount -Rl /mnt
    sudo zpool export -a

