#!/bin/sh
set -e

devices="1002:731f,1002:ab38,10ec:5762"

export grub_content="GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 amd_iommu=on vfio-pci.ids=$devices pcie_acs_override=downstream,multifunction\""

grep -q "amd_iommu=on" /etc/default/grub || {
  sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=.*|$grub_content|g" /etc/default/grub;
  update-grub;
}

grep -q "vfio" /etc/initramfs-tools/modules || {
  echo "softdep amdgpu pre: vfio vfio-pci";
  echo "softdep nvme pre: vfio vfio-pci";
  echo vfio;
  echo vfio_iommu_type1;
  echo vfio_virqfd;
  echo "options vfio-pci ids=$devices";
  echo "vfio-pci ids=$devices";
  echo vfio-pci;
  echo amdgpu;
} >> /etc/initramfs-tools/modules

grep -q "vfio" /etc/modules || {
  echo vfio;
  echo vfio_iommu_type1;
  echo vfio-pci;
  echo "options vfio-pci ids=$devices";
  echo "vendor-reset"
} >> /etc/modules

# # echo "softdep amdgpu pre: vfio vfio-pci" > /etc/modprobe.d/amdgpu.conf
# # echo "options vfio-pci ids=$devices" > /etc/modprobe.d/vfio-pci.conf
{
  echo "options vfio-pci ids=$devices";
  echo "softdep amdgpu pre: vfio vfio-pci";
  echo "softdep nvme pre: vfio vfio-pci";
} > /etc/modprobe.d/vfio.conf

update-initramfs -u
