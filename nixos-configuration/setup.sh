#!/bin/sh

sudo chown ab /etc/nixos
sudo chown ab /etc/nixos/*

ln -s /etc/nixos/hardware-configuration.nix $HOME/.dotfiles/nixos-configuration/hardware-configuration.nix
ln -s $HOME/.dotfiles/nixos-configuration/configuration.nix /etc/nixos/configuration.nix
