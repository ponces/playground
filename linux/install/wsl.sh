#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

if [ -z "$WSL_DISTRO_NAME" ]; then
    echo "This script is intended for WSL. Exiting..."
    exit 1
fi

$SUDO apt-get update
$SUDO apt-get install -y wslu xdg-utils

if ! grep -q "systemd" /etc/wsl.conf; then
    printf "\n[boot]\nsystemd = true\n" | $SUDO tee -a /etc/wsl.conf
fi
if ! grep -q "hostname" /etc/wsl.conf; then
    printf "\n[network]\nhostname = ubuntu\n" | $SUDO tee -a /etc/wsl.conf
fi
if ! grep -q "default" /etc/wsl.conf; then
    printf "\n[user]\ndefault = ponces\n" | $SUDO tee -a /etc/wsl.conf
fi

if [ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    $SUDO tee /etc/systemd/system/wsl-interop-fix.service >/dev/null << 'EOF'
[Unit]
Description=Fix WSL Interop naming conflict for wslu utilities
After=systemd-binfmt.service
Wants=systemd-binfmt.service

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo ":WSLInterop:M::MZ::/init:P" | tee /proc/sys/fs/binfmt_misc/register'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
    $SUDO systemctl daemon-reload
    $SUDO systemctl enable --now wsl-interop-fix.service
fi
