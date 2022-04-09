#!/bin/sh
export installation_disk

export root_password
export user_name
export user_password

export boot_name="boot"
export swap_name="swap"
export root_name="arch"

export boot_start="1"
export boot_end="512"

export swap_size
export swap_start
export swap_end

export partitions    
export boot_partition
export swap_partition
export root_partition


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
  swap_partition=$( echo "$partitions" | grep "Linux swap" | awk '{ printf $1}')
  root_partition=$( echo "$partitions" | grep "Linux filesystem" | awk '{ printf $1}')

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

  echo "---------- Finished mount_partitions() ----------"
}

fstab() {
  pacstrap /mnt base base-devel linux linux-firmware

  genfstab -U /mnt >> /mnt/etc/fstab
  echo "---------- Finished fstab() ----------"
}

install_packages() {
  arch-chroot /mnt pacman -S --noconfirm --needed - < packages.txt
  echo "---------- Finished install_packages() ----------"
}

system_config() {
  arch-chroot /mnt ln -sf /usr/share/zoneinfo/Asia/Riyadh /etc/localtime

  arch-chroot /mnt hwclock --systohc

  arch-chroot /mnt sed -i 's|#ar_SA.UTF-8 UTF-8|ar_SA.UTF-8 UTF-8|1' /etc/locale.gen
  arch-chroot /mnt sed -i 's|#en_US.UTF-8 UTF-8|en_US.UTF-8 UTF-8|1' /etc/locale.gen
  arch-chroot /mnt locale-gen

  arch-chroot /mnt printf "LANG=en_US.UTF-8" > /etc/locale.conf
  arch-chroot /mnt printf "KEYMAP=us" > /etc/vconsole.conf
  arch-chroot /mnt printf "desktop-arch" > /etc/hostname

  arch-chroot /mnt mkinitcpio -P
  arch-chroot /mnt printf "%s\n%s" "$root_password" "$root_password" | passwd
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
      printf "You chose %s. Confirm ? Y/n " "$installation_disk"
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
  install_packages
  system_config
}


main
