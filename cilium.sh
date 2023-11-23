#!/usr/bin/env bash
set -euo pipefail

helm repo add cilium https://helm.cilium.io
helm install \
	-n kube-system \
	cilium cilium/cilium \
	--version '1.14.4' \
	-f <(cat <<EOF
k8sServiceHost: 127.0.0.1
k8sServicePort: 6443
cluster:
  name: "local"
envoy:
  enabled: true
envoyConfig:
  enabled: true
hostPort:
  enabled: true
ingressController:
  enabled: true
  default: true
  loadbalancerMode: "shared"
  enforceHttps: false
kubeProxyReplacement: true
loadBalancer:
  l7:
    backend: envoy
nodeinit:
  enabled: true
nodePort:
  enabled: true
operator:
  rollOutPods: true
  replicas: 1
serviceAccounts:
  nodeinit:
    enabled: true
socketLB:
  enabled: true
rollOutCiliumPods: true
wellKnownIdentities:
  enabled: true
EOF
)
