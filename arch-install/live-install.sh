#!/bin/sh
set -e
boot_name="boot"
swap_name="swap"
root_name="arch"

boot_start="1"
boot_end="512"

partition_disk() {
  boot_end+="MB"
  swap_start+="MB"
  swap_end+="MB"

  if ! grep -i "Finished partition_disk()" log > /dev/null; then
    parted -s "$installation_disk"                                  \
      mklabel gpt                                                   \
      mkpart "$boot_name" fat32 "$boot_start" "$boot_end"           \
      set 1 boot on                                                 \
      mkpart "$swap_name" "linux-swap(v1)" "$boot_end" "$swap_size" \
      mkpart "$root_name" ext4 "$swap_end" 100%
  fi


  partitions=$(fdisk -l | grep "^$installation_disk")
  boot_partition=$( echo "$partitions" | grep "EFI System" | awk '{ printf $1}')
  swap_partition=$( echo "$partitions" | grep "Linux swap" | awk '{ printf $1 }')
  root_partition=$( echo "$partitions" | grep "Linux filesystem" | awk '{ printf $1 }')

  echo "Finished partition_disk()" >> log
}

format_partitions() {
  grep -i "Finished format_partitions()" log > /dev/null && return

  mkfs.ext4 "$root_partition"
  mkswap "$swap_partition"
  mkfs.fat -F 32 "$boot_partition"

  echo "Finished format_partitions()" >> log
}

mount_partitions() {
  grep -i "Finished mount_partitions()" log > /dev/null && return

  mount "$root_partition" /mnt
  mount --mkdir "$boot_partition" /mnt/boot
  swapon "$swap_partition"


  hdd_path=$(fdisk -l | grep -B 1 "ST2000DM008-2FR1" | sed 1q | awk -F ":| " '{ printf $2 }')
  if [ -n "$hdd_path" ]; then
    linux_hdd_part= "$(fdisk -x | grep "Linux" | awk '{print $1}')"
    mount "$linux_hdd_part" /mnt/mnt/linuxHDD
  fi

  echo "Finished mount_partitions()" >> log
}

main() {
  touch log


  installation_disk=""
  export user_name=""
  export host_name=""
  export root_password=""
  export user_password=""

  swap_size=$((8 * 1024))
  swap_start=$(( "$boot_end" ))
  swap_end=$(( "$boot_end" + "$swap_size"))

  [ -z "$installation_disk" ] && echo "Set values in the script" && exit 1
  [ -z "$swap_size" ] && echo "Set values in the script" && exit 1
  [ -z "$root_password" ] && echo "Set values in the script" && exit 1
  [ -z "$user_name" ] && echo "Set values in the script" && exit 1
  [ -z "$user_password" ] && echo "Set values in the script" && exit 1
  [ -z "$host_name" ] && echo "Set values in the script" && exit 1
  [ -z "$swap_start" ] && echo "Set values in the script" && exit 1
  [ -z "$swap_end" ] && echo "Set values in the script" && exit 1

  timedatectl set-ntp true

  partition_disk
  format_partitions
  mount_partitions

  sed -i "s|#ParallelDownloads = 5|ParallelDownloads = 6|g" /etc/pacman.conf
  pacstrap /mnt base base-devel linux linux-firmware
  genfstab -U /mnt >> /mnt/etc/fstab

  # Save vars to use in config script
  mkdir -p /mnt/install_tmp
  cp packages.txt  \
  config-system.sh \
  config-user.sh   \
  -t /mnt/install_tmp

  sed -i "s|#ParallelDownloads = 5|ParallelDownloads = 6|g" /mnt/etc/pacman.conf
  arch-chroot /mnt bash -c "pacman -S --noconfirm --needed - < /install_tmp/packages.txt"
  arch-chroot /mnt bash -c "/install_tmp/config-system.sh"
  arch-chroot /mnt bash -c "su "$user_name" -c /install_tmp/config-user.sh"

  rm -rf /mnt/install_tmp

  printf "System installed and configured.\n"
}

main
