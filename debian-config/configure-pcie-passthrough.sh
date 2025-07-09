#!/bin/sh
set -e

devices="1002:731f,1002:ab38,10ec:5762"

export grub_content="GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 amd_iommu=on vfio-pci.ids=$devices pcie_acs_override=downstream,multifunction\""

grep -q "$grub_content" /etc/default/grub || {
  sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=.*|$grub_content|g" /etc/default/grub;
  update-grub;
}

update_initram=false
if ! grep -q "vfio" /etc/initramfs-tools/modules; then
    {
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
    update_initram=true
fi

if ! grep -q "vfio" /etc/modules; then
    {
        echo vfio;
        echo vfio_iommu_type1;
        echo vfio-pci;
        echo "options vfio-pci ids=$devices";
        echo "vendor-reset"
    } >> /etc/modules
    update_initram=true
fi

# # echo "softdep amdgpu pre: vfio vfio-pci" > /etc/modprobe.d/amdgpu.conf
# # echo "options vfio-pci ids=$devices" > /etc/modprobe.d/vfio-pci.conf

if ! grep -q "options vfio-pci" /etc/modprobe.d/vfio.conf; then
    {
        echo "options vfio-pci ids=$devices";
        echo "softdep amdgpu pre: vfio vfio-pci";
        echo "softdep nvme pre: vfio vfio-pci";
    } > /etc/modprobe.d/vfio.conf
    update_initram=true
fi

if "$update_initram"; then
    update-initramfs -u
fi
