#!/bin/bash

echo "deb [trusted=yes] https://apt.fury.io/versionfox/ /" | sudo tee /etc/apt/sources.list.d/versionfox.list
sudo apt update
sudo apt install -y vfox
 
vfox add dotnet gradle java kubectl nodejs

echo 'eval "$(vfox activate bash)"' >> $HOME/.bash_profile
