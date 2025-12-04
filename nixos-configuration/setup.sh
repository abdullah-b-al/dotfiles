#!/bin/sh

if [ $USER = "root" ]; then
    echo "Must run as regular user"
    exit 1
fi

sudo chown $USER /etc/nixos
sudo chown $USER /etc/nixos/*

ln -s $HOME/.dotfiles/nixos-configuration/configuration.nix /etc/nixos/configuration.nix
ln -s $HOME/.dotfiles/nixos-configuration/flake.nix /etc/nixos/flake.nix
