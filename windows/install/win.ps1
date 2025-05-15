# Stop at first error
$ErrorActionPreference = 'Stop'

function Update-EnvironmentPath {
    param($Directory)
    $CurrentPATH = [Environment]::GetEnvironmentVariable("Path", "User")
    $NewPATH = $Directory + ";" + $CurrentPATH
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
}

winget install AgileBits.1Password Bitwarden.CLI Canonical.Ubuntu dbeaver.dbeaver Docker.DockerCLI `
               Docker.DockerCompose Fortinet.FortiClientVPN Genymobile.scrcpy Git.Git Google.Chrome `
               Google.PlatformTools Hashicorp.Vagrant JanDeDobbeleer.OhMyPosh jdx.mise jqlang.jq `
               M2Team.NanaZip Microsoft.DotNet.SDK.3_1 Microsoft.DotNet.SDK.6 Microsoft.DotNet.SDK.8 `
               Microsoft.PowerShell Microsoft.Teams Microsoft.Office Microsoft.VisualStudioCode `
               OBSProject.OBSStudio okibcn.nano RedHat.OpenShift-Client RedHat.Podman RedHat.Podman-Desktop `
               Starpine.Screenbox twpayne.chezmoi WinDirStat.WinDirStat WinMerge.WinMerge ZhornSoftware.Caffeine

$env:BW_SESSION = (bw unlock --raw)
if (-not $?)
{
    $env:BW_SESSION = (bw login --raw)
}
chezmoi init --apply ponces

mise use --global gradle@8.6
mise use --global helm
mise use --global helmfile
mise use --global java@17
mise use --global kubectl
mise use --global node@20

New-Item -Path "$env:APPDATA\apktool" -ItemType Directory -Force | Out-Null
curl -sfSL https://go.ponces.xyz/apktool -o "$env:APPDATA\apktool\apktool.ps1"
git clone -q https://github.com/dahlbyk/posh-git $env:APPDATA\posh-git
oh-my-posh font install CascadiaCode

Update-EnvironmentPath -Directory "$env:APPDATA\apktool"
Update-EnvironmentPath -Directory "$env:LOCALAPPDATA\mise\shims"

if (-not (Test-Path $PROFILE)) {
    New-Item $PROFILE -Type File -ErrorAction Stop -Force | Out-Null
}
Add-Content -Path $PROFILE -Value "oh-my-posh init pwsh --config ""$env:POSH_THEMES_PATH\robbyrussell.omp.json"" | Invoke-Expression"
Add-Content -Path $PROFILE -Value "Import-Module ""$env:APPDATA\posh-git\src\posh-git.psd1"""
Add-Content -Path $PROFILE -Value "function sshcode() { code --remote ssh-remote+ubuild01 @Args }"

setx ClientConfiguration__SecurityPortalBaseAddress "https://portalqa.criticalmanufacturing.dev/SecurityPortal/"
setx ClientConfiguration__ClientTenantName "CustomerPortalQA"
setx ClientConfiguration__HostAddress "portalqa.criticalmanufacturing.dev:443"
