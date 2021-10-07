#!/bin/bash

TMPDIR=/var/tmp
USER="admin"
PASSWORD="admin"
ROOTPASSWORD="ronindojoroot"
FULLNAME="RoninDojo"
TIMEZONE="UTF-8"
LOCALE="en_US.UTF-8"
HOSTNAME="RoninDojo"
KEYMAP="us"

create_oem_install() {
    echo "Setting root password..."
    chpasswd <<<"root:$ROOTPASSWORD"

    echo "Adding user $USER..."
    useradd -m -G wheel,sys,audio,input,video,storage,lp,network,users,power,docker -s /bin/bash "$USER" &>/dev/null

    echo "Setting full name to $FULLNAME..."
    chfn -f "$FULLNAME" "$USER" &>/dev/null

    echo "Setting password for $USER..."
    chpasswd <<<"$USER:$PASSWORD"

    echo "Setting timezone to $TIMEZONE..."
    timedatectl set-timezone $TIMEZONE &>/dev/null
    timedatectl set-ntp true &>/dev/null

    echo "Generating $LOCALE locale..."
    sed -i "s/#$LOCALE/$LOCALE/" /etc/locale.gen &>/dev/null
    locale-gen &>/dev/null
    localectl set-locale $LOCALE &>/dev/null

    if [ -f /etc/sway/inputs/default-keyboard ]; then
        sed -i "s/us/$KEYMAP/" /etc/sway/inputs/default-keyboard

        if [ "$KEYMAP" = "uk" ]; then
            sed -i "s/uk/gb/" /etc/sway/inputs/default-keyboard
        fi
    fi

    echo "Setting hostname to $HOSTNAME..."
    hostnamectl set-hostname $HOSTNAME &>/dev/null

    echo "Resizing partition..."
    resize-fs &>/dev/null

    echo "Cleaning install for unwanted files..."
    sudo rm -rf /var/log/*

    loadkeys "$KEYMAP"

    echo "Configuration complete. Cleaning up..."
    rm /root/.bash_profile

    sed -i -e "s/PermitRootLogin yes/#PermitRootLogin prohibit-password/" \
        -e "s/PermitEmptyPasswords yes/#PermitEmptyPasswords no/" /etc/ssh/sshd_config
}

if ! systemctl is-active --quiet dhcpcd.service; then
   systemctl enable --quiet --now dhcpcd.service
fi

if ! systemctl is-active --quiet avahi-daemon.service; then
   systemctl disable systemd-resolved.service &>/dev/null
   systemctl enable --quiet --now avahi-daemon.service
fi

create_oem_install

if ! systemctl is-enabled motd.service; then
   systemctl enabled --quiet --now motd.service
fi

echo -e "domain .local\nnameserver 8.8.8.8\nnameserver 8.8.4.4\nnameserver 1.1.1.1" >> /etc/resolv.conf

echo "OEM complete"
cat /etc/motd

systemctl enable --quiet ronin-setup.service
systemctl disable --quiet oem-boot.service