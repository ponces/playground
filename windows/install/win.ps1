# Stop at first error
$ErrorActionPreference = 'Stop'

function Update-EnvironmentPath {
    param($Directory)
    $CurrentPATH = [System.Environment]::GetEnvironmentVariable("PATH", "User") -Split ";"
    $NewPATH = ($CurrentPATH + $Directory) -Join ";"
    [System.Environment]::SetEnvironmentVariable("PATH", $NewPath, "User")
}

winget install AgileBits.1Password Canonical.Ubuntu dbeaver.dbeaver Docker.DockerCLI Docker.DockerCompose `
               Fortinet.FortiClientVPN Genymobile.scrcpy Git.Git Google.Chrome Google.PlatformTools `
               Hashicorp.Vagrant Helm.Helm JanDeDobbeleer.OhMyPosh M2Team.NanaZip `
               Microsoft.DotNet.SDK.3_1 Microsoft.DotNet.SDK.6 Microsoft.DotNet.SDK.8 `
               Microsoft.PowerShell Microsoft.Teams Microsoft.Office Microsoft.VisualStudioCode `
               OBSProject.OBSStudio okibcn.nano RedHat.OpenShift-Client RedHat.Podman RedHat.Podman-Desktop `
               Starpine.Screenbox WinDirStat.WinDirStat WinMerge.WinMerge version-fox.vfox ZhornSoftware.Caffeine

# Install vfox plugins
Invoke-Expression "$(vfox activate pwsh)"
vfox add gradle java kubectl nodejs
vfox install gradle@8.6 java@17 kubectl@1.30.2 nodejs@20
vfox use -g gradle@8.6
vfox use -g java@17
vfox use -g kubectl@1.30.2
vfox use -g nodejs@20

# Install utils
git clone -q https://gist.github.com/9b17662d281c734b7977d4ea48959953.git $env:APPDATA\apktool
git clone -q https://github.com/dahlbyk/posh-git $env:APPDATA\posh-git
oh-my-posh font install CascadiaCode

# Update path
Update-EnvironmentPath -Directory "$env:APPDATA\apktool"

# Create $PROFILE if it doesn't exist
if (-not (Test-Path $PROFILE)) {
  New-Item $PROFILE -Type File -ErrorAction Stop -Force | Out-Null
}

# Update $PROFILE
Add-Content -Path $PROFILE -Value 'Invoke-Expression "$(vfox activate pwsh)"'
Add-Content -Path $PROFILE -Value "oh-my-posh init pwsh --config ""$env:POSH_THEMES_PATH\robbyrussell.omp.json"" | Invoke-Expression"
Add-Content -Path $PROFILE -Value "Import-Module ""$env:APPDATA\posh-git\src\posh-git.psd1"""

# Update .gitconfig
git config --global alias.pushfwl "push --force-with-lease"
git config --global core.editor "nano"
git config --global core.longpaths true
git config --global color.ui "auto"
git config --global fetch.prune true
git config --global fetch.pruneTags true
git config --global http.sslBackend "schannel"
git config --global pull.rebase true
git config --global push.autoSetupRemote true
git config --global rebase.autosquash true
git config --global user.name "Alberto Ponces"
git config --global user.email "albertoponces@criticalmanufacturing.com"

# Set portal-sdk env vars
setx ClientConfiguration__SecurityPortalBaseAddress "https://portalqa.criticalmanufacturing.dev/SecurityPortal/"
setx ClientConfiguration__ClientTenantName "CustomerPortalQA"
setx ClientConfiguration__HostAddress "portalqa.criticalmanufacturing.dev:443"
