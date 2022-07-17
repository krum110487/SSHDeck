# SSHDeck
Installer for the Steam Deck that will create a "sdcard" user and temporarily enable SSH.

### Installing:
Simply download the `Install.sh` and run the command `sudo ./Install.sh`
It will automatically put the desktop file in place as well as the required file.

If you have a password on the deck user and do not want to input it every time, you can modify the file found at `/home/deck/SSHToggle/ToggleSSH.sh` and update the line `PASSWORD="DEFAULT_EMPTY_VALUE"` to the password for the `deck` user.

### Usage:
Clicking on the new "ToggleSSH.desktop" will popup, closing this popup will turn of SSH.
