#!/bin/sh

for i in $(seq 0 10); do
    master="My Tablet Device"
    master_id="$(xinput list --id-only "$master pointer")"
    tablet="OpenTabletDriver Virtual Artist Tablet Pen (0)"
    tablet_id="$(xinput list --id-only "$tablet")"


    if [ -n "$tablet_id" ]; then
        if ! [ "$(xinput list | grep "$master")" ]; then
            xinput create-master "$master"
        fi

        xinput float "$tablet_id"
        xinput reattach "$tablet_id" "$master_id"
        exit 0
    fi

    sleep 1
done
