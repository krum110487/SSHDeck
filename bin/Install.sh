#!/bin/bash

# Revert to the backup, remove user
#\cp /etc/ssh/sshd_config.backup /etc/ssh/sshd_config
#userdel -r sdcard
#groupdel sdcard

#Backup file, if the backup doesn't exist
FILE="/etc/ssh/sshd_config.backup"
if [ ! -f "$FILE" ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
else
    echo "sshd_config is already backed up."
fi

# Create the group, if it does not exist.
if grep -q -E "^sdcard:" /etc/group; then
    echo "sdcard group already exists."
else
    groupadd sdcard
    chgrp -R sdcard /run/media
fi

# Create the user, if it does not exist.
if id "sdcard" &>/dev/null; then
    echo 'User "sdcard" already exists.'
else
    useradd --home-dir /run/media/ --shell /bin/bash -g sdcard sdcard
    passwd -d sdcard
fi

# Setup chroot jail for user.
if grep -Fxq "Match user sdcard" /etc/ssh/sshd_config
then
    echo 'sshd_config already contains text needed for chroot jail.'
else
    # Comment out the line "Subsystem	sftp	/usr/lib/ssh/sftp-server"
    sed -i 's/Subsystem	sftp	\/usr\/lib\/ssh\/sftp-server/#Subsystem	sftp	\/usr\/lib\/ssh\/sftp-server/g' /etc/ssh/sshd_config

    # Add the information below so that the sdcard user is confined to /run/media, cannot navigate elsewhere.
    echo 'Subsystem	sftp	internal-sftp' >> /etc/ssh/sshd_config
    echo '' >> /etc/ssh/sshd_config
    echo '#Add this section to match for user "sdcard"' >> /etc/ssh/sshd_config
    echo 'Match user sdcard' >> /etc/ssh/sshd_config
    echo '	ChrootDirectory /run/media' >> /etc/ssh/sshd_config
    echo '	X11Forwarding no' >> /etc/ssh/sshd_config
    echo '	AllowTcpForwarding no' >> /etc/ssh/sshd_config
    echo '	PermitTunnel no' >> /etc/ssh/sshd_config
    echo '	AllowAgentForwarding no' >> /etc/ssh/sshd_config
    echo '	ForceCommand internal-sftp' >> /etc/ssh/sshd_config
    echo '	PasswordAuthentication yes' >> /etc/ssh/sshd_config
    echo '	PermitEmptyPasswords yes' >> /etc/ssh/sshd_config
fi

# Create folder if it doesn't exist
mkdir -p /home/deck/SSHToggle

# Pull the ToggleSSH.sh
curl --create-dirs -O --output-dir /home/deck/SSHToggle https://raw.githubusercontent.com/krum110487/SSHDeck/main/bin/ToggleSSH.sh
chmod +x "/home/deck/SSHToggle/ToggleSSH.sh"

# Pull the Desktop icon
curl --create-dirs -O --output-dir /home/deck/Desktop https://raw.githubusercontent.com/krum110487/SSHDeck/main/bin/ToggleSSH.desktop
chmod +x "/home/deck/Desktop/ToggleSSH.desktop"