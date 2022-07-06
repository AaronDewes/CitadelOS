#!/bin/bash

set -ex

sudo test -d /var/cache/manjaro-arm-tools/img || exit 1
cd /var/cache/manjaro-arm-tools/img

for i in Manjaro-ARM-RoninOS-*.xz; do
	sudo bash -c "sha256sum $i >sum"
	test -f "${i}".asc && sudo rm "${i}".asc
	gpg -u "${user:-gpg@ronindojo.io}" --output "${i}".asc --pinentry-mode=loopback --batch --passphrase "$(<"$HOME"/.gpg-passwd)" --clearsign sum
	sudo rm sum
done
