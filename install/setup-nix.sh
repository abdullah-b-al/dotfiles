#!/bin/sh
set -e
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
nix-env -if ~/.dotfiles/install/packages.nix
