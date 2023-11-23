#!/usr/bin/env bash
# shellcheck disable=2174
set -xeuo pipefail

role='worker'
packages=(
	'container-selinux'
	'k3s-install'
	'k3s-selinux'
	'nfs-client'
)
if [[ "${NEW_ROLE}" == 'master' ]]; then
	role='master'
	packages+=(
		'etcdctl'
		'helm'
		'k9s'
		'rancher-cli'
	)
fi

zypper --non-interactive install "${packages[@]}"

# Install k3s service
install -m600 \
	files/"k3s-install.${role}.service" \
	/etc/systemd/system/k3s-install.service
systemctl enable k3s-install.service

# Install any CRDs
mkdir -pm700 /var/lib/rancher/k3s/server/manifests
install -m600 \
	manifests/*.yaml \
	/var/lib/rancher/k3s/server/manifests/

# Configure etcdctl
install -m755 \
	files/etcdctl-k3s \
	/usr/bin/etcdctl-k3s

# Configure root kube config
mkdir -m700 /root/.kube
ln -sf \
	/etc/rancher/k3s/k3s.yaml \
	/root/.kube/config
