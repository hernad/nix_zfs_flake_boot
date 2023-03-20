zfs create \
  -o canmount=off \
  -o mountpoint=none \
  rpool/nixos

zfs create -o mountpoint=legacy rpool/nixos/root
mount -t zfs rpool/nixos/root /mnt/

# home
mkdir /mnt/home
zfs create -o mountpoint=legacy rpool/nixos/home
mount -t zfs  rpool/nixos/home /mnt/home

# nix
mkdir -pv /mnt/nix
zfs create -o mountpoint=legacy rpool/nixos/nix

# var/log
zfs create -o mountpoint=legacy  rpool/nixos/var
zfs create -o mountpoint=legacy rpool/nixos/var/log

zfs create -o mountpoint=none bpool/nixos
zfs create -o mountpoint=legacy bpool/nixos/root
mkdir -pv /mnt/boot
mount -t zfs bpool/nixos/root /mnt/boot

zfs create -o mountpoint=legacy rpool/nixos/empty
zfs snapshot rpool/nixos/empty@start

mkfs.vfat -n EFI /dev/nvme0n1p5
mkdir -p /mnt/boot/efis/nvme0n1p5
mount -t vfat /dev/nvme0n1p5 /mnt/boot/efis/nvme0n1p5


