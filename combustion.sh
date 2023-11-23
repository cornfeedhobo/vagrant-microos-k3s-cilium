#!/usr/bin/env bash
set -euo pipefail

NAME="${1:-combustion}"

TMP_IMG="$(mktemp)"

# 20mb image
sudo dd if=/dev/zero of="${TMP_IMG}" bs=1024 count=20000
sudo mkfs.vfat -F 16 -n 'COMBUSTION' "${TMP_IMG}"

# mount and copy
sudo mount -o loop "${TMP_IMG}" /mnt
sudo cp -r combustion /mnt/combustion
sudo umount /mnt

mv "${TMP_IMG}" "${NAME}.img"
