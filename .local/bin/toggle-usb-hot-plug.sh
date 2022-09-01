#!/bin/sh
virsh -c "qemu:///system" attach-device win10 --live --file "$HOME/usb.xml" --config || 
  virsh -c "qemu:///system" detach-device win10 --live --file "$HOME/usb.xml" --config
