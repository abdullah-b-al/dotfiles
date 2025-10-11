#!/usr/bin/env bash

sudo apt install pipewire pipewire-pulse pipewire-audio-client-libraries libspa-0.2-bluetooth

systemctl --user --now enable pipewire
systemctl --user --now enable pipewire-pulse
