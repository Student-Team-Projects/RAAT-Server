# RAAT Server

This is a simple script which runs a desktop environment (for the time being, only [LXDE](https://wiki.archlinux.org/title/LXDE) and [XFCE](https://wiki.archlinux.org/title/XFCE) is supported) on a virtual display, which can be accessed with a VNC client. 
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
makepkg -si
```

## Usage
# Desktop Session Manager

A command-line tool for managing remote desktop sessions with VNC support.
The tool supports three main operations:

### Opening a New Session

```bash
raat-server-request open-session --vnc_password=<pass> --rfb_port=<port> --geometry=<WxH> --de_choice=<lxde|xfce>
```

#### Parameters:
- `vnc_password`: Password for VNC client authentication
- `rfb_port`: Port number for RFB (Remote Framebuffer) protocol communication (recommended range: 5901-5909)
- `geometry`: Display resolution in format `WIDTHxHEIGHT` (e.g., `800x600`)
- `de_choice`: Desktop environment choice (`lxde` or `xfce`)

### Killing an Existing Session

```bash
raat-server-request kill-session --rfb_port=<port>
```

#### Parameters:
- `rfb_port`: Port number of the session to terminate

### Checking Session Status

```bash
raat-server-request get-session-status --rfb_port=<port>
```

#### Parameters:
- `rfb_port`: Port number of the session to check

## Examples

1. Creating a new session with detailed syntax:
```bash
raat-server-request open-session --vnc_password=mysecret --rfb_port=5901 --geometry=1024x768 --de_choice=xfce
```

2. Creating a new session with simple syntax:
```bash
raat-server-request mysecret 5901 1024x768
```

3. Terminating a session:
```bash
raat-server-request kill-session --rfb_port=5901
```

4. Checking session status:
```bash
raat-server-request get-session-status --rfb_port=5901
```

## Notes

- Always use secure passwords for VNC authentication
- Ensure the chosen RFB port is available and within the recommended range
- The geometry setting must follow the `WIDTHxHEIGHT` format exactly
- When using the simple syntax, parameters must be provided in the correct order

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
sudo systemctl status sshd
```

## License
This project is licensed under GPL 3.0.
