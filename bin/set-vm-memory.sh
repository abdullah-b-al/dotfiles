#!/bin/sh
memory="$1"
[ -z $memory ] && echo "must provide amount of memory in megabytes" && exit 1
echo "setting memory of VM 'win10' to "$memory" megabytes"
sudo virsh setmem --domain win10 --size "$memory"M --current
