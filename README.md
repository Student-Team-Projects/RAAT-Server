# RAAT Server

This is a simple script which runs a desktop environment (for the time being, only [cinnamon DE](https://wiki.archlinux.org/title/cinnamon) is supported) on a virtual display, which can be accessed with a VNC client. 
This script is meant to be launched by the RAAT android app, but can also be used independently.

## Name
RAAT stands for 'Remote Archlinux Android Tool', an android app for easier VNC configuration on arch linux.

## Description
raat-server uses Xvnc, based on a standard X server, but it has a "virtual" screen rather than a physical one.

## Installation
This is an Arch linux package. To install, run:
```
git clone [link to project]
makepkg -i
```

## Usage
```
raat-server [vnc password] [rfb port] [geometry]
```

- vnc password - password which will be used by the vnc client to access the remote desktop
- rfb port - port for communication, typically within the range (5901-5909)
- geometry - a string of format \[width\]x\[height\], e.g. 800x600

## License
This project is licensed under GPL 3.0.

