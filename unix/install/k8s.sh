#!/bin/bash

set -e

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="server --disable traefik" sh -s -
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> $HOME/.bashrc

curl -skSL https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/v1.16.0/deploy/install-driver.sh | bash -s "v1.16.0" --
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.0/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
