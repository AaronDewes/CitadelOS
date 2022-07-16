#!/bin/bash

rm /etc/motd

bash -c "cat <<EOF > /etc/motd
Welcome to Citadel!

Website:   runcitadel.space
EOF"

touch /tmp/motd-actived