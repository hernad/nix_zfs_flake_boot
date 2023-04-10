if [ ! -f ./scripts/part.sh ]; then
   echo ./scripts/part.sh not exists
   exit 1
fi

source ./scripts/part.sh

zpool list 

mkdir -p /mnt/boot

mount -t zfs rpool/nixos/root /mnt

mkdir -pv /mnt/nix
mount -t zfs rpool/nixos/nix /mnt/nix

mkdir -pv /mnt/boot
mount -t zfs bpool/nixos/root /mnt/boot

mkdir -pv /mnt/boot/efis/${installDisk##*/}p${P_EFI}
mount -t vfat /dev/${installDisk##*/}p${P_EFI} /mnt/boot/efis/${installDisk##*/}p${P_EFI}


 echo =================== results ========================

 mount | grep zfs
 mount | grep vfat
 