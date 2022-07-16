#!/bin/bash

while systemctl is-active --quiet citadel-setup.service
do
    echo "Citadel still installing..."
    sleep 5s
    if ! systemctl is-active --quiet citadel-setup.service
    then
        echo "restarting pm2..."
        pm2 resurrect
        break
    fi
done