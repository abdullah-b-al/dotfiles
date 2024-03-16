#!/bin/sh
set -e

[ -z "$user_password" ] && echo "Enter Password:" && read user_password
echo $user_password | sudo -S apt build-dep --assume-yes libvirt

cd /tmp

libvirt="libvirt-10.1.0"
tar_libvirt="/tmp/$libvirt.tar.xz"
touch $HOME/.config/wgetrc
[ -f $tar_libvirt ] || wget -O $tar_libvirt https://download.libvirt.org/$libvirt.tar.xz
[ -d $libvirt ] || xz -dc $tar_libvirt | tar xvf -

cd $libvirt
meson setup --reconfigure build -Dsystem=true -Ddocs=disabled -Dprefix=/usr/local -Dtests=disabled
ninja -C build
echo $user_password | sudo -S ninja -C build install
echo $user_password | sudo -S ldconfig
