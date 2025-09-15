$ErrorActionPreference = 'Stop'

winget install JanDeDobbeleer.OhMyPosh Microsoft.PowerShell

git clone -q https://github.com/dahlbyk/posh-git $env:APPDATA/posh-git
oh-my-posh font install CascadiaCode

if (-not (Test-Path $PROFILE)) {
    New-Item $PROFILE -Type File -ErrorAction Stop -Force | Out-Null
}
Add-Content -Path $PROFILE -Value "oh-my-posh init pwsh --config ""`$env:POSH_THEMES_PATH/robbyrussell.omp.json"" | Invoke-Expression"
Add-Content -Path $PROFILE -Value "Import-Module ""`$env:APPDATA/posh-git/src/posh-git.psd1"""
