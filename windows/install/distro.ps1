$ErrorActionPreference = "Stop"

$DownloadedFilePath = "$env:TMP/distro.tar.gz"
$DownloadUrl = "https://cloud-images.ubuntu.com/wsl/releases/noble/current/ubuntu-noble-wsl-amd64-wsl.rootfs.tar.gz"

if (!$DistroName) {
    $Uuid = [System.IO.Path]::GetFileNameWithoutExtension([System.IO.Path]::GetRandomFileName())
    $DistroName = "test-$Uuid"
}

Invoke-WebRequest -Uri $DownloadUrl -OutFile $DownloadedFilePath
wsl --install --version 2 --name $DistroName --from-file $DownloadedFilePath
wsl -d $DistroName
