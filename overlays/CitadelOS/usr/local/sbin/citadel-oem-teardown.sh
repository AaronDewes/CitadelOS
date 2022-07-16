#!/bin/bash

echo "Removing OEM files ..."

if [ -f /tmp/citadel-oem-activated ]; then
   rm /tmp/citadel-oem-activated
   touch /tmp/citadel-oem-teardown

   if ! systemctl is-active citadel-setup.service; then
      systemctl start citadel-setup.service
   fi
else
   echo "Doesn't seem to be working: Skipping ..."
   exit
fi

#systemctl reboot