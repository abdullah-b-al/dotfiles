#!/bin/sh

# arg $1 is the operation
# arg $2 is the vendor and product of the device format xxxx:xxxx
plug() {
  vp="$2"
  vendor="$(echo "$vp" | cut -d ':' -f 1 -)"
  product="$(echo "$vp" | cut -d ':' -f 2 -)"

  xml="<hostdev mode=\"subsystem\" type=\"usb\" managed=\"yes\">
  <source>
  <vendor id=\"0x$vendor\"/>
  <product id=\"0x$product\"/>
  </source>
  </hostdev>
  "

  file="$HOME/usb.xml"
  printf "%s" "$xml" > "$file"


  operation="$1"
  if [ "$operation" = "attach" ]; then
    virsh -c "qemu:///system" attach-device win10 --file  "$file" --current

  elif [ "$operation" = "detach" ]; then
      virsh -c "qemu:///system" detach-device win10 --file "$file" --current 

  elif [ "$operation" = "toggle" ]; then
    virsh -c "qemu:///system" attach-device win10 --file  "$file" --current ||
      virsh -c "qemu:///system" detach-device win10 --file "$file" --current
        elif [ "$operation" = "force-attach" ]; then
          virsh -c "qemu:///system" detach-device win10 --file "$file" --current
          virsh -c "qemu:///system" attach-device win10 --file  "$file" --current
        else
          echo "must provide attach, detach, toggle or force-attach"
          rm "$file"
          exit 1
  fi

  rm "$file"
}

if [ -t 0 ]; then
  alias menu="fzf"
else
  alias menu="rofi -dmenu -matching fuzzy -i"
fi

operation="$1"
if [ -z "$1" ]; then
    operation="$(printf "%s\n%s\n%s\n%s\n" "force-attach" "attach" "detach" "toggle" | menu)"
    [ -z "$operation" ] && exit 1
fi

device="$2"
if [ -z "$2" ]; then
    device="$(lsusb | menu | cut -d ' ' -f 6)"
    [ -z "$device" ] && exit 1
fi

result="$(plug "$operation" "$device" 2>&1)"

if [ -z "$1" ] || [ -z "$2" ]; then
    notify-send -t 5000 "$result"
else
    echo "$result"
fi
