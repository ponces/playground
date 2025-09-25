#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

user="ponces"
pass="ponces"

$SUDO apt-get update
$SUDO apt-get install -y sudo

if ! command -v useradd >/dev/null; then
    $SUDO addgroup "$user"
    $SUDO adduser "$user" --home "/home/$user" --gecos "$user" --ingroup "$user" --shell "/bin/bash"
else
    $SUDO groupadd "$user"
    $SUDO useradd "$user" --create-home --home-dir "/home/$user" --gid "$user" --shell "/bin/bash"
fi

echo $user:$pass | chpasswd

$SUDO adduser "$user" sudo

if [ -f /etc/wsl.conf ]; then
    printf "[user]\ndefault = $user\n" | $SUDO tee -a /etc/wsl.conf
fi
