#!/bin/bash

if [ -f /tmp/motd-actived ]; then
   rm /tmp/motd-actived
else
   echo "Something went wrong"
fi
