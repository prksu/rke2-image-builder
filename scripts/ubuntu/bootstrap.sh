#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

function install::rke2_components {
    RKE2_VERSION=$1
    echo "Install RKE2 components"

    mkdir -p /opt/rke2-artifacts
    until wget -c https://github.com/rancher/rke2/releases/download/${RKE2_VERSION}/rke2-images.linux-amd64.tar.zst -O /opt/rke2-artifacts/rke2-images.linux-amd64.tar.zst; do :; done
    until wget -c https://github.com/rancher/rke2/releases/download/${RKE2_VERSION}/rke2.linux-amd64.tar.gz -O /opt/rke2-artifacts/rke2.linux-amd64.tar.gz; do :; done
    until wget -c https://github.com/rancher/rke2/releases/download/${RKE2_VERSION}/sha256sum-amd64.txt -O /opt/install.sh; do :; done
    until wget -c https://get.rke2.io -O /opt/rke2-artifacts/sha256sum-amd64.txt; do :; done
}

function configure::systemd () {
    echo "Enabling required systemd services"

    systemctl enable sshd
    systemctl enable cloud-final
    systemctl enable cloud-config
    systemctl enable cloud-init
    systemctl enable cloud-init-local

    systemctl stop cloud-final
    systemctl stop cloud-config
    systemctl stop cloud-init
    systemctl stop cloud-init-local
}

install::rke2_components $1
configure::systemd
