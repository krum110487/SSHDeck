#!/bin/bash
MYDIR="$(dirname "$(readlink -f "$0")")"
PASSWORD="DEFAULT_EMPTY_VALUE"

if sudo -n true 2>/dev/null; then 
    HASPASSWORD=false
else
    HASPASSWORD=true
fi

if $HASPASSWORD; then
    if [ $PASSWORD == "DEFAULT_EMPTY_VALUE" ]; then
        PASSWORD=zenity --entry --text "sudo is password protected, please enter the password."
    fi
fi

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

if zenity --info --text "SSH server has started and Sleep mode is disabled, it will stay that way until you close this window." --no-wrap --ok-label "Stop SSH"
then
    if $HASPASSWORD; then
        printf "$PASSWORD\n" | sudo -S systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
        printf "$PASSWORD\n" | sudo -S systemctl stop sshd
    else
        sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
        sudo systemctl stop sshd
    fi
fi

