#!/bin/sh

# arg $1 is the operation
# arg $2 is the vendor and product of the device format xxxx:xxxx

vp="$2"
vendor="$(echo $vp | cut -d ':' -f 1 -)"
product="$(echo $vp | cut -d ':' -f 2 -)"

xml="<hostdev mode=\"subsystem\" type=\"usb\" managed=\"yes\">
  <source>
  <vendor id=\"0x$vendor\"/>
  <product id=\"0x$product\"/>
  </source>
</hostdev>
"

file="$HOME/usb.xml"
printf "$xml" > $file

operation="$1"
if [ "$operation" = "attach" ]; then
  virsh -c "qemu:///system" attach-device win10 --live --file  $file --config

elif [ "$operation" = "detach" ]; then
  virsh -c "qemu:///system" detach-device win10 --live --file $file --config

elif [ "$operation" = "toggle" ]; then
  virsh -c "qemu:///system" attach-device win10 --live --file  $file --config ||
    virsh -c "qemu:///system" detach-device win10 --live --file $file --config
  elif [ "$operation" = "force-attach" ]; then
      virsh -c "qemu:///system" detach-device win10 --live --file $file --config
      virsh -c "qemu:///system" attach-device win10 --live --file  $file --config
else
    echo "must provide attach, detach, toggle or force-attach"
    rm "$file"
    exit 1
fi

rm "$file"
