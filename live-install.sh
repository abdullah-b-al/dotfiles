#!/bin/sh
export root_password
export user_name
export user_password

boot_name="boot"
swap_name="swap"
root_name="arch"

boot_start="1"
boot_end="512"


update_system_clock() {
  timedatectl set-ntp true
  echo "---------- Finished update_system_clock() ----------"
}

partition_disk() {
  boot_end+="MB"
  swap_start+="MB"
  swap_end+="MB"

  parted -s "$installation_disk"                                  \
    mklabel gpt                                                   \
    mkpart "$boot_name" fat32 1 "$boot_end"                       \
    set 1 boot on                                                 \
    mkpart "$swap_name" "linux-swap(v1)" "$boot_end" "$swap_size" \
    mkpart "$root_name" ext4 "$swap_end" 100%


  partitions=$(fdisk -l | grep "^$installation_disk")
  boot_partition=$( echo "$partitions" | grep "EFI System" | awk '{ printf $1}')
  swap_partition=$( echo "$partitions" | grep "Linux swap" | awk '{ printf $1 }')
  root_partition=$( echo "$partitions" | grep "Linux filesystem" | awk '{ printf $1 }')

  echo "---------- Finished partition_disk() ----------"
}

format_partitions() {

  mkfs.ext4 "$root_partition"
  mkswap "$swap_partition"
  mkfs.fat -F 32 "$boot_partition"

  echo "---------- Finished format_partitions() ----------"
}

mount_partitions() {
  mount "$root_partition" /mnt
  mount --mkdir "$boot_partition" /mnt/boot
  swapon "$swap_partition"


  hdd_path=$(fdisk -l | grep -B 1 "ST2000DM008-2FR1" | sed 1q | awk -F ":| " '{ printf $2 }')
  [ -n "$hdd_path" ] && mount "$hdd_path" /mnt/mnt/linuxHDD

  echo "---------- Finished mount_partitions() ----------"
}

fstab() {
  pacstrap /mnt base base-devel linux linux-firmware

  genfstab -U /mnt >> /mnt/etc/fstab
  echo "---------- Finished fstab() ----------"
}

install_packages() {
  arch-chroot /mnt bash -c "pacman -S --noconfirm --needed - < /install_tmp/packages.txt"
  echo "---------- Finished install_packages() ----------"
}

main() {
  # Get disk to be installed on
  while true; do
    disks=$(fdisk -l)
    echo "$disks"
    printf "Type path of disk to install --> "
    read -r installation_disk

    disks=$(echo "$disks" | grep -i "Disk /dev/" | awk -F ":| " '{print $2}' | grep -i "$installation_disk")
    if [ "$disks" = "$installation_disk" ]; then
      printf "You chose %s. Confirm ? Y/n\n" "$installation_disk"
      fdisk -l "$installation_disk" | sed '2!d'
      read -r disk_answer
      
      if [ "$disk_answer" = "y" ] || [ "$disk_answer" = "Y" ]; then
        break
      fi
    fi
  done

  # Get ram size and set swap_size
  while true; do
    free -h
    printf "Choose size of swap in GB --> "
    read -r swap_size
    
    printf "Swap size is %sGB. Confirm ? Y/n " "$swap_size"
    read -r swap_answer
    if [ "$swap_answer" = "y" ] || [ "$swap_answer" = "Y" ]; then
      # Convert to MB
      swap_size=$(( "$swap_size" * 1024))

      swap_start=$(( "$boot_end" ))
      swap_end=$(( "$boot_end" + "$swap_size"))
      break
    fi
  done

  # Get root password
  while true; do
    printf "\n\n"
    printf "Choose root password --> "
    read -r root_password

    printf "Confirm root password --> "
    read -r second_root_password

    if [ "$root_password" != "$second_root_password" ]; then
      printf "Root passwords don't match."
      continue
    fi

    printf "%s. Confirm password ? Y/n " "$root_password"
    read -r answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
      break
    fi
  done

  # Get user name
  while true; do
    printf "\n\n"
    printf "Choose user name --> "
    read -r user_name
    printf "%s. Confirm name ? Y/n " "$user_name"
    read -r answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
      break
    fi
  done

  # Get user password
  while true; do
    printf "\n\n"
    printf "Choose user password --> "
    read -r user_password

    printf "Confirm user password --> "
    read -r second_user_password

    if [ "$user_password" != "$second_user_password" ]; then
      printf "User passwords don't match."
      continue
    fi

    printf "%s. Confirm password ? Y/n " "$user_password"
    read -r answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
      break
    fi
  done


  update_system_clock
  partition_disk
  format_partitions
  mount_partitions
  fstab

  # Save vars to use in config script
  mkdir -p /mnt/install_tmp
  cp packages.txt  \
  config-system.sh \
  -t /mnt/install_tmp

  install_packages
  arch-chroot /mnt bash -c "/install_tmp/config-system.sh"

  rm -rf /mnt/install_tmp

  printf "System install and configured. Press any key to reboot"
  read c
  reboot
}


main
