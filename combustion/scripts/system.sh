#!/usr/bin/env bash
# shellcheck disable=2174
set -xeuo pipefail

# Set hostname
echo "${NEW_HOSTNAME}" >/etc/hostname
chmod 420 /etc/hostname

# Install basics
zypper --non-interactive install \
	avahi \
	bash-completion \
	bind-utils \
	htop \
	iotop \
	jq \
	nss-mdns

# Enable avahi
systemctl enable avahi-daemon.service

# Enable systemd ntp
systemctl enable systemd-timesyncd.service

# Configure rebootmgr
install -m600 \
	files/rebootmgr.conf \
	/etc/rebootmgr.conf

# Limit transaction-update runs to be less frequent
mkdir -pm755 /etc/systemd/system/transactional-update.timer.d
install -m600 \
	files/transactional-update.timer.d.conf \
	/etc/systemd/system/transactional-update.timer.d/override.conf

# Better xcp-ng support
install -m600 \
	files/xen-vcpu-hotplug.rules \
	/usr/lib/udev/rules.d/80-xen-vcpu-hotplug.rules

# Configure SSH for key auth
cat >/etc/ssh/sshd_config.d/auth.conf <<-EOF
	PubkeyAuthentication yes
	PasswordAuthentication no
	PermitRootLogin no
EOF

# Expand the filesystem to fill the given volume
devices=(
	'sda'
	'vda'
	'xvda'
)
for device in "${devices[@]}"; do
	if [ -f "/dev/${device}" ]; then
		growpart "/dev/${device}" 3
		btrfs filesystem resize max /
	fi
done
