# Install zfs root

    nix flake clone github:hernad/nix_zfs_flake_boot --dest hernad
    cd hernad

    # sudo zpool import -f rpool bpool
    # sudo bash scripts/mount_zfs.sh

    sudo nixos-install --flake .#lenovo16

    sudo umount -Rl /mnt
    sudo zpool export -a

