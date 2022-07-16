**To replicate this build you must do the following:**

1) Have Manjaro Linux (x86-64)
2) Install make with `sudo pacman -qS --noconfirm make`
3) Run `make install` to install
4) Edit "$HOME"/.gpg-passwd with password to Citadel gpg key
5) Run `citadelos --user="gpg@ronindojo.io" --generate`
6) Run `shred -fuzn24 "$HOME"/.gpg-passwd` (optional but recommended)

**To check on setup scripts:**

1) Flash the image you created using the steps above to micro SD card
2) Make sure HDMI screen, keyboard, and ethernet cable are plugged in
3) Power on the device 
4) Run `journalctl -u citadel-setup -f`

**File structure:**

- _citadelos:_ Build script to generate Manjaro OS images for various single board computers.
- _tool-libs/functions.sh:_ Contains modifications specific for CitadelOS under the buildrootfs function. This mainly is used to enable oem-boot service to run at boot.
- _overlays/CitadelOS/usr/local/sbin/citadel-oem-fast.sh:_ This is a modification of the Manjaro Linux ARM oem script to ensure other services are enabled and user is setup during boot. This is also where the username, passwd, locale, keyboard are setup.
- _overlays/CitadelOS/usr/local/sbin/citadel-setup.sh:_ Automates the install of Citadel to allow end users to access Citadel UI during install process.
- _overlays/CitadelOS/etc/avahi:_ Configuration for the citadel.local access.
- _overlays/CitadelOS/etc/plymouth:_ Custom boot theme for RoninOS.
- _overlays/CitadelOS/systemd/system/getty@tty1.service.d/override.conf:_ Enable auto login to terminal on initial boot.
- _services/CitadelOS:_ Services that execute on boot.
