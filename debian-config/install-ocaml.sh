#!/bin/sh

[ "$1" != "force" ] && command -v opam && echo Already installed && exit 0

wget --no-config -O /tmp/opam https://github.com/ocaml/opam/releases/download/2.3.0/opam-2.3.0-x86_64-linux
install --mode +x /tmp/opam -t ~/.local/bin
opam init --no-setup --compiler=5.2.0
opam install -y ocamlformat utop
