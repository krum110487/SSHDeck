#!/bin/bash
MYDIR="$(dirname "$(readlink -f "$0")")"
PASSWORD="DEFAULT_EMPTY_VALUE"

# Get IP Addresses
ip4=$(/sbin/ip -o -4 addr list wlan0 | awk '{print $4}' | cut -d/ -f1)
ip6=$(/sbin/ip -o -6 addr list wlan0 | awk '{print $4}' | cut -d/ -f1)


# Check if there is a password for sudo.
if sudo -n true 2>/dev/null; then 
    HASPASSWORD=false
else
    HASPASSWORD=true
fi

# If it has a password, AND they have net set it, popup to ask for the password.
if $HASPASSWORD; then
    if [ $PASSWORD == "DEFAULT_EMPTY_VALUE" ]; then
        PASSWORD=zenity --entry --text "sudo is password protected, please enter the password."
    fi
fi

# Start sshd and suspend sleep
if $HASPASSWORD; then
    printf "$PASSWORD\n" | sudo -S systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    printf "$PASSWORD\n" | sudo -S systemctl start sshd
else
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    sudo systemctl start sshd
fi

# Wait for the sshd daemon to finish launching
while ! pgrep -f "sshd" > /dev/null; do
    sleep 0.1
done

# Show the popup and on close, disable ssh and re-enable sleep
if zenity --info --text "`printf "SSH server has started and Sleep mode is disabled, it will stay that way until you close this window.\nHost Name:\nPort Number: 22\nUser Name: sdcard or deck"`" --no-wrap --ok-label "Stop SSH"
then
    if $HASPASSWORD; then
        printf "$PASSWORD\n" | sudo -S systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
        printf "$PASSWORD\n" | sudo -S systemctl stop sshd
    else
        sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
        sudo systemctl stop sshd
    fi
fi

