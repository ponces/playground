$ErrorActionPreference = 'Stop'

function Update-EnvironmentPath {
    param($Directory)
    $CurrentPATH = [Environment]::GetEnvironmentVariable("Path", "User")
    $NewPATH = $Directory + ";" + $CurrentPATH
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
}

$downloadUrl="https://nightly.link/mpv-player/mpv/workflows/build/master/mpv-x86_64-pc-windows-msvc.zip"
New-Item -Path "$env:APPDATA/mpv" -ItemType Directory -Force | Out-Null
Invoke-WebRequest -Uri $downloadUrl -OutFile "$env:APPDATA/mpv/mpv.zip"
Expand-Archive -Path "$env:APPDATA/mpv/mpv.zip" -DestinationPath "$env:APPDATA/mpv" -Force
Remove-Item -Path "$env:APPDATA/mpv/mpv.zip" -Force

Update-EnvironmentPath -Directory "$env:APPDATA/mpv"
