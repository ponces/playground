#!/bin/bash

set -e

user="ponces"
pass="ponces"

apt install -y sudo

if ! command -v useradd &>/dev/null; then
    addgroup "$user"
    adduser "$user" --home "/home/$user" --gecos "$user" --ingroup "$user" --shell "/bin/bash"
else
    groupadd "$user"
    useradd "$user" --create-home --home-dir "/home/$user" --gid "$user" --shell "/bin/bash"
fi

echo $user:$pass | chpasswd

adduser "$user" sudo

[ -f /etc/wsl.conf ] && printf "[user]\ndefault = $user\n" >> /etc/wsl.conf
  