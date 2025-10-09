#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

id="1001"
user="ponces"
pass="ponces"

$SUDO apt-get update
$SUDO apt-get install -y sudo

if ! command -v useradd >/dev/null; then
    $SUDO addgroup "$user" --gid "$id"
    $SUDO adduser "$user" --home "/home/$user" --gecos "$user" --uid "$id" --ingroup "$user" --shell "/bin/bash"
else
    $SUDO groupadd "$user" --gid "$id"
    $SUDO useradd "$user" --create-home --home-dir "/home/$user" --uid "$id" --gid "$id" --shell "/bin/bash"
fi

echo $user:$pass | chpasswd

$SUDO adduser "$user" sudo

if [ -f /etc/wsl.conf ] && ! grep -q "default" /etc/wsl.conf; then
    printf "[user]\ndefault = $user\n" | $SUDO tee -a /etc/wsl.conf
fi
