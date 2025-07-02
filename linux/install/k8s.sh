#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

curl -sfSL https://get.k3s.io | bash -s -

mkdir -p $HOME/.kube
$SUDO cp -f /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
$SUDO chown $USER:$USER $HOME/.kube/config
chmod 600 $HOME/.kube/config

curl -skSL https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/v1.16.0/deploy/install-driver.sh | bash -s "v1.16.0" --
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.0/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml

curl -sfSL https://go.ponces.xyz/k9s | bash
