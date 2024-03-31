#!/bin/sh

# arg $1 is the operation
# arg $2 is the vendor and product of the device format xxxx:xxxx
plug() {
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
}

if [ -t 0 ]; then
  alias menu="fzf --layout=reverse --height=1%"
  alias print="echo "
else
  alias menu="rofi -dmenu -matching fuzzy -i"
  alias print="notify-send -t 5000"
fi

if [ -z "$1" ]; then
  selection="$(lsusb | menu | cut -d ' ' -f 6)"
  [ -z "$selection" ] && exit 1
  operation="$(printf "%s\n%s\n%s\n%s\n" "force-attach" "attach" "detach" "toggle" | menu)"
  [ -z "$operation" ] && exit 1

  result="$(plug "$operation" "$selection" 2>&1)"
  print "$result"
else 
  plug "$1" "$2"
fi
