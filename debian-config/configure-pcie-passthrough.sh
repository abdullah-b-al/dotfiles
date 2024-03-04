#!/bin/sh
set -e

devices="1002:731f,1002:ab38,10ec:5762"

export grub_content="GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 amd_iommu=on vfio-pci.ids=$devices pcie_acs_override=downstream,multifunction\""

grep -q "amd_iommu=on" /etc/default/grub || {
  sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=.*|$grub_content|g" /etc/default/grub;
  update-grub;
}

grep -q "vfio" /etc/initramfs-tools/modules || {
  echo "softdep amdgpu pre: vfio vfio_pci";
  echo vfio;
  echo vfio_iommu_type1;
  echo vfio_virqfd;
  echo "options vfio_pci ids=$devices";
  echo "vfio_pci ids=$devices";
  echo vfio_pci;
  echo amdgpu;
} >> /etc/initramfs-tools/modules

grep -q "vfio" /etc/modules || {
  echo vfio;
  echo vfio_iommu_type1;
  echo vfio_pci;
  echo "options vfio_pci ids=$devices";
} >> /etc/modules

# # echo "softdep amdgpu pre: vfio vfio_pci" > /etc/modprobe.d/amdgpu.conf
# # echo "options vfio_pci ids=$devices" > /etc/modprobe.d/vfio_pci.conf
{
  echo "options vfio_pci ids=$devices";
  echo "softdep amdgpu pre: vfio vfio_pci";
} > /etc/modprobe.d/vfio.conf

update-initramfs -u
