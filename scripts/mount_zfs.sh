mkdir -p /mnt/boot

mount -t zfs rpool/nixos/root /mnt

mkdir -pv /mnt/nix
mount -t zfs rpool/nixos/nix /mnt/nix


mkdir -pv /mnt/boot
mount -t zfs bpool/nixos/root /mnt/boot

mkdir -pv /mnt/boot/efis/nvme0n1p5
mount -t vfat /dev/nvme0n1p5 /mnt/boot/efis/nvme0n1p5


 