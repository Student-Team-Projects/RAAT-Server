# RAAT Server

This is a simple script which runs a desktop environment (for the time being, only [LXDE](https://wiki.archlinux.org/title/LXDE) is supported) on a virtual display, which can be accessed with a VNC client. 
This script is meant to be launched by the RAAT android app, but can also be used independently.

## Name
RAAT stands for 'Remote Archlinux Android Tool', an android app for easier VNC configuration on arch linux.

## Description
raat-server uses Xvnc, based on a standard X server, but it has a "virtual" screen rather than a physical one.
Raat-server sessions are active until explicitly killed. Upon starting a raat-server a VNC viewer window will appear.
The VNC viewer window can be opened using raat-connect command.

## Installation
This is an Arch linux package. To install, run:

```
git clone [link to project]
makepkg -i
```

## Usage
To start a VNC session:

```
raat-server [vnc password] [rfb port] [geometry]
```

- vnc password - password which will be used by the vnc client to access the remote desktop
- rfb port - port for communication, typically within the range (5901-5909)
- geometry - a string of format \[width\]x\[height\], e.g. 800x600

To list all active VNC sessions:

```
raat-connect
```

To start a VNC viewer for a session on a given port:

```
raat-connect [rfb port]
```

- rfb port - a port for communication on which the server is listening

If you want to connect to a VNC session via SSH, remember to open a port for SSH connections, e.g.:

```
sudo systemctl stat sshd
```

## License
This project is licensed under GPL 3.0.
