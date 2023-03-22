#!/bin/sh

zip -r "$1".zip "$1"

sudo cp -r "$1".zip "$2"

rm -rf "$1.zip"
