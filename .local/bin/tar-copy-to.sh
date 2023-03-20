#!/bin/sh

tar cf "$1".tar "$1"

sudo cp -r "$1".tar "$2"

rm -rf "$1.tar"
