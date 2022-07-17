# SSHDeck
Installer for the Steam Deck that will create a "sdcard" user and temporarily enable SSH until the popup is closed. This is useful for beginners to use a program like [WinSCP](https://winscp.net/eng/index.php) to login to their steam deck remotely to put files onto the SD card as needed.

### Installing:
Simply download the `Install.sh` found [HERE](https://raw.githubusercontent.com/krum110487/SSHDeck/main/bin/Install.sh) (right click and save link as to the downloads folder) then run the command 
```
sudo cd "/home/deck/Downloads"; chmod +x ./Install.sh; ./Install.sh
```
It will automatically put the desktop file in place as well as the required file.

If you have a password on the deck user and do not want to input it every time, you can modify the file found at `/home/deck/SSHToggle/ToggleSSH.sh` and update the line `PASSWORD="DEFAULT_EMPTY_VALUE"` to the password for the `deck` user.

### Usage:
Clicking on the new `ToggleSSH.desktop` will popup with information needed to login, closing this popup will turn off SSH, sleep or restarting will also stop SSH, so it will only work while the popup is there.

### TODO:
I need to experiment with a .desktop file that uses curl to run the installer, but I don't want to reformat. I believe [SSHDeck_Install](https://raw.githubusercontent.com/krum110487/SSHDeck/main/SSHDeck_Install.desktop) should work as expected, but it is untested as of right now.

Should probably require/prompt the user to input a password for "deck" when installing, could automatically update the script to include the password in it.