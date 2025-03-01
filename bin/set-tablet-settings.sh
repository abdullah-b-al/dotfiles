#!/bin/sh

master="My Tablet Device"

if ! [ "$(xinput list | grep "$master")" ]; then
    xinput create-master "$master"
fi

master_id="$(xinput list --id-only "$master pointer")"
tablet="OpenTabletDriver Virtual Artist Tablet Pen (0)"
tablet_id="$(xinput list --id-only "$tablet")"

xinput float "$tablet_id"
xinput reattach "$tablet_id" "$master_id"
