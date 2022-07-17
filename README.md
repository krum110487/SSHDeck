# SSHDeck
Installer for the Steam Deck that will create a "sdcard" user and temporarily enable SSH.

### Installing:
Simply download the `Install.sh` found [here](https://raw.githubusercontent.com/krum110487/SSHDeck/main/Install.sh) (right click and save link as) then run the command `sudo ./Install.sh`
It will automatically put the desktop file in place as well as the required file.

If you have a password on the deck user and do not want to input it every time, you can modify the file found at `/home/deck/SSHToggle/ToggleSSH.sh` and update the line `PASSWORD="DEFAULT_EMPTY_VALUE"` to the password for the `deck` user.

### Usage:
Clicking on the new `ToggleSSH.desktop` will popup with information needed to login, closing this popup will turn off SSH, sleep or restarting will also stop SSH, so it will only work while the popup is there.
