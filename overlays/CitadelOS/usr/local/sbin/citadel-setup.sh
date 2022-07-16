#!/bin/bash

# Clone Repo
git clone -b main https://github.com/runcitadel/core "$HOME"/citadel

# Source files
cd "$HOME"/citadel || exit

# Spin up a minimal web server in python to show that Citadel is booting
./scripts/citadel-os/init
# Download all dependencies
./scripts/citadel-os/bootstrap
# Configure OS to autostart Citadel
./scripts/citadel-os/install
# Stop webserver
./scripts/citadel-os/stop-server
# Start Citadel
./scripts/citadel-os/start
