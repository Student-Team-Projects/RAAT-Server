#!/bin/bash
# Clean package files
rm -rf pkg/ src/
rm -f *.zst

makepkg -ci