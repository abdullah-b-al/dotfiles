#!/usr/bin/env bash

dnf copr enable -y atim/starship

dnf install -y dnf-plugins-core

dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

dnf install -y $(cat ./fedora-packages.txt)
