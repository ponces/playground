$ErrorActionPreference = 'Stop'

function Update-EnvironmentPath {
    param($Directory)
    $CurrentPATH = [Environment]::GetEnvironmentVariable("Path", "User")
    $NewPATH = $Directory + ";" + $CurrentPATH
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
}

#$path = $(Get-Item $(Get-Command adb).Source).Directory.Parent.FullName
$ANDROID_HOME = "$env:USERPROFILE/.android/sdk"

setx ANDROID_HOME "$ANDROID_HOME"
setx ANDROID_AVD_HOME "$ANDROID_HOME/avd"

Update-EnvironmentPath "$ANDROID_HOME/build-tools"
Update-EnvironmentPath "$ANDROID_HOME/cmdline-tools/latest/bin"
Update-EnvironmentPath "$ANDROID_HOME/platform-tools"

Invoke-WebRequest -Uri "https://dl.google.com/android/repository/commandlinetools-win-13114758_latest.zip" -OutFile "$env:TEMP/sdk.zip"
Expand-Archive -Path "$env:TEMP/sdk.zip" -DestinationPath "$ANDROID_HOME/cmdline-tools" -Force
Remove-Item -Path "$env:TEMP/sdk.zip" -Force
Move-Item -Path "$ANDROID_HOME/cmdline-tools/cmdline-tools" -Destination "$ANDROID_HOME/cmdline-tools/latest" -Force

Start-Process -FilePath "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager.bat" -ArgumentList "--install", "build-tools;36.0.0", `
                                                                                                           "cmake;4.1.1", `
                                                                                                           "ndk;28.2.13676358", `
                                                                                                           "platform-tools", `
                                                                                                           "platforms;android-36" `
                                                                                                           -Wait -NoNewWindow

Start-Process -FilePath "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager.bat" -ArgumentList "--install", "emulator", `
                                                                                                           "system-images;android-36;google_apis;x86_64" `
                                                                                                           -Wait -NoNewWindow
Start-Process -FilePath "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager.bat" -ArgumentList "create", "avd", "--force", `
                                                                                                               "--name", "Pixel9", `
                                                                                                               "--device", "pixel_9", `
                                                                                                               "--abi", "google_apis/x86_64", `
                                                                                                               "--package", "system-images;android-36;google_apis;x86_64" `
                                                                                                               -Wait -NoNewWindow

Start-Process -FilePath "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager.bat" -ArgumentList "--licenses" -Wait -NoNewWindow

New-Item -Path "$env:APPDATA/apktool" -ItemType Directory -Force | Out-Null
curl -sfSL https://go.ponces.dev/apktool -o "$env:APPDATA/apktool/apktool.ps1"
