#!/bin/bash

if [ -f /tmp/citadel-activated ]; then
   rm /tmp/citadel-activated
else
   echo "Something went wrong"
fi
