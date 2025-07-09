#!/bin/sh

temps="$(sensors amdgpu-pci-1000 | grep -e "junction" -e "mem" -e "edge" | sed "s/: */ /g" | cut -f 2 -d '+' | cut -f 1 -d ".")"

sum=0
count=0
for temp in $temps; do
    sum=$((sum + temp))
    count=$((count + 1))
done

echo "$((sum / count))"
