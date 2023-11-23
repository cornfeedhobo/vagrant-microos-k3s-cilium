#!/usr/bin/env bash
# shellcheck disable=2174
set -xeuo pipefail

passwd -d root
passwd -l root

for user in "${NEW_USERS[@]}"; do
	useradd -m -s /bin/bash -g users "${user}"
	mkdir -pm700 "/home/${user}/.ssh"
	curl -sL \
		"https://github.com/${user}.keys" \
		>>"/home/${user}/.ssh/authorized_keys"
	chmod 600 "/home/${user}/.ssh/authorized_keys"
	chown -R "${user}:users" "/home/${user}"
	passwd -d "${user}"
	passwd -l "${user}"
	echo "${user} ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers.d/adminusers
done
