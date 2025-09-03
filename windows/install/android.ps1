$ErrorActionPreference = 'Stop'

function Update-EnvironmentPath {
    param($Directory)
    $CurrentPATH = [Environment]::GetEnvironmentVariable("Path", "User")
    $NewPATH = $Directory + ";" + $CurrentPATH
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
}

$path = $(Get-Item $(Get-Command adb).Source).Directory.Parent.FullName
setx ANDROID_HOME "$path"
Update-EnvironmentPath "$path/build-tools"
Update-EnvironmentPath "$path/cmdline-tools/latest/bin"
Update-EnvironmentPath "$path/platform-tools"

Invoke-WebRequest -Uri "https://dl.google.com/android/repository/commandlinetools-win-13114758_latest.zip" -OutFile "$env:TEMP\sdk.zip"
Expand-Archive -Path "$env:TEMP\sdk.zip" -DestinationPath "$path/cmdline-tools" -Force
Remove-Item -Path "$env:TEMP\sdk.zip" -Force
Move-Item -Path "$path/cmdline-tools/cmdline-tools" -Destination "$path/cmdline-tools/latest" -Force

Start-Process -FilePath "$path/cmdline-tools/latest/bin/sdkmanager.bat" -ArgumentList "--install", "build-tools;35.0.0", "cmake;3.31.1", "ndk;27.1.12297006", "platform-tools", "platforms;android-35" -Wait -NoNewWindow

New-Item -Path "$env:APPDATA/apktool" -ItemType Directory -Force | Out-Null
curl -sfSL https://go.ponces.dev/apktool -o "$env:APPDATA/apktool/apktool.ps1"
