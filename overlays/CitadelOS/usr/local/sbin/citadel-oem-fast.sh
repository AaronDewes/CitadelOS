#!/bin/bash

TMPDIR=/var/tmp
USER="citadel"
FULLNAME="Citadel"
TIMEZONE="UTC"
LOCALE="en_US.UTF-8"
HOSTNAME="citadel"
KEYMAP="us"

create_oem_install() {
    # Adding user $USER
    useradd -m -G wheel,sys,audio,input,video,storage,lp,network,users,power,docker -s /bin/bash "$USER" &>/dev/null

    # Setting full name to $FULLNAME
    chfn -f "$FULLNAME" "$USER" &>/dev/null

    # Setting password for $USER
    chpasswd <<<"$USER:freedom"

    # Setting timezone to $TIMEZONE
    timedatectl set-timezone $TIMEZONE &>/dev/null
    timedatectl set-ntp true &>/dev/null

    # Generating $LOCALE locale
    sed -i "s/#$LOCALE/$LOCALE/" /etc/locale.gen &>/dev/null
    locale-gen &>/dev/null
    localectl set-locale $LOCALE &>/dev/null

    if [ -f /etc/sway/inputs/default-keyboard ]; then
        sed -i "s/us/$KEYMAP/" /etc/sway/inputs/default-keyboard

        if [ "$KEYMAP" = "uk" ]; then
            sed -i "s/uk/gb/" /etc/sway/inputs/default-keyboard
        fi
    fi

    # Setting hostname to $HOSTNAME
    hostnamectl set-hostname $HOSTNAME &>/dev/null

    # Resizing partition
    resize-fs &>/dev/null

    # Cleaning install for unwanted files
    sudo rm -rf /var/log/*

    loadkeys "$KEYMAP"

    # Configuration complete. Cleaning up
    rm /root/.bash_profile

    # Avahi setup
    sed -i 's/hosts: .*$/hosts: files mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns mdns/' /etc/nsswitch.conf
    sed -i 's/.*host-name=.*$/host-name=citadel/' /etc/avahi/avahi-daemon.conf
    systemctl restart avahi-daemon

    if ! systemctl is-enabled --quiet avahi-daemon; then
        systemctl enable --quiet avahi-daemon
    fi

    # sshd setup
    sed -i -e "s/PermitRootLogin yes/#PermitRootLogin prohibit-password/" \
        -e "s/PermitEmptyPasswords yes/#PermitEmptyPasswords no/" /etc/ssh/sshd_config

    # Enable password less sudo
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-nopasswd
}

if ! systemctl is-active --quiet dhcpcd.service; then
   systemctl enable --quiet --now dhcpcd.service
fi

if ! systemctl is-active --quiet avahi-daemon.service; then
   systemctl disable systemd-resolved.service &>/dev/null
   systemctl enable --quiet --now avahi-daemon.service
fi

if ! systemctl is-enabled motd.service; then
   systemctl enabled --quiet --now motd.service
fi

create_oem_install

echo -e "domain .local\nnameserver 1.1.1.1\nnameserver 1.0.0.1" >> /etc/resolv.conf

echo "OEM complete"
cat /etc/motd

systemctl enable --quiet --now citadel-setup.service
systemctl disable --quiet oem-boot.service
