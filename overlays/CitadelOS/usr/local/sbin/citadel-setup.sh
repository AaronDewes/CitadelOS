#!/bin/bash

# Clone Repo
git clone -b main https://github.com/runcitadel/core "$HOME"/citadel

# Source files
cd "$HOME"/citadel || exit

# Spin up a minimal web server in python to show that Citadel is booting
./scripts/citadel-os/init
# Download all dependencies
./scripts/citadel-os/bootstrap

# Restart node
sudo reboot
