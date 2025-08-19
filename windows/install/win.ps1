# Stop at first error
$ErrorActionPreference = 'Stop'

function Update-EnvironmentPath {
    param($Directory)
    $CurrentPATH = [Environment]::GetEnvironmentVariable("Path", "User")
    $NewPATH = $Directory + ";" + $CurrentPATH
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
}

winget install Bitwarden.Bitwarden Canonical.Ubuntu Genymobile.scrcpy Git.Git Google.Chrome `
               Google.PlatformTools JanDeDobbeleer.OhMyPosh jdx.mise jqlang.jq M2Team.NanaZip `
               Microsoft.PowerShell Microsoft.Teams Microsoft.Office Microsoft.VisualStudioCode `
               OBSProject.OBSStudio okibcn.nano Starpine.Screenbox twpayne.chezmoi `
               WinDirStat.WinDirStat WinMerge.WinMerge ZhornSoftware.Caffeine

chezmoi init --apply ponces

mise use --global gradle@8.6
mise use --global helm
mise use --global helmfile
mise use --global java@17
mise use --global kubectl
mise use --global node@20

New-Item -Path "$env:APPDATA\apktool" -ItemType Directory -Force | Out-Null
curl -sfSL https://go.ponces.dev/apktool -o "$env:APPDATA\apktool\apktool.ps1"

$downloadUrl="https://nightly.link/mpv-player/mpv/workflows/build/master/mpv-x86_64-pc-windows-msvc.zip"
New-Item -Path "$env:APPDATA\mpv" -ItemType Directory -Force | Out-Null
Invoke-WebRequest -Uri $downloadUrl -OutFile "$env:APPDATA\mpv\mpv.zip"
Expand-Archive -Path "$env:APPDATA\mpv\mpv.zip" -DestinationPath "$env:APPDATA\mpv" -Force
Remove-Item -Path "$env:APPDATA\mpv\mpv.zip" -Force

git clone -q https://github.com/dahlbyk/posh-git $env:APPDATA\posh-git
oh-my-posh font install CascadiaCode

Update-EnvironmentPath -Directory "$env:APPDATA\apktool"
Update-EnvironmentPath -Directory "$env:APPDATA\mpv"
Update-EnvironmentPath -Directory "$env:LOCALAPPDATA\mise\shims"

if (-not (Test-Path $PROFILE)) {
    New-Item $PROFILE -Type File -ErrorAction Stop -Force | Out-Null
}
Add-Content -Path $PROFILE -Value "oh-my-posh init pwsh --config ""$env:POSH_THEMES_PATH\robbyrussell.omp.json"" | Invoke-Expression"
Add-Content -Path $PROFILE -Value "Import-Module ""$env:APPDATA\posh-git\src\posh-git.psd1"""
Add-Content -Path $PROFILE -Value "function sshcode() { code --remote ssh-remote+ponces@ubuild01.ponces.dev @Args }"

$ShortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Caffeine.lnk"
$Shortcut = (New-Object -COMObject WScript.Shell).CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = (Get-Command caffeine64).Source
$Shortcut.Arguments = "-startoff -stes"
$Shortcut.Save()
