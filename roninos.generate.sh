#!/bin/bash

set -ex

sudo getarmprofiles -f;

sudo cp -vf tools-lib/functions.sh /usr/share/manjaro-arm-tools/lib/
sudo cp -vf editions/RoninOS /usr/share/manjaro-arm-tools/profiles/arm-profiles/editions/
sudo cp -vf services/RoninOS /usr/share/manjaro-arm-tools/profiles/arm-profiles/services/
sudo cp -vrf overlays/RoninOS /usr/share/manjaro-arm-tools/profiles/arm-profiles/overlays/RoninOS
#sudo cp roninos /usr/local/sbin/
#sudo chmod +x /usr/local/sbin/roninos

ls -la /usr/share/manjaro-arm-tools/lib/

#List: on2 quartz64-bsp rpi4 rock64 rockpi4b rockpi4c rockpro64
sudo buildarmimg -d rockpro64 -e RoninOS