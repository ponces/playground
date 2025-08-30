$ErrorActionPreference = 'Stop'

winget install Bitwarden.Bitwarden Canonical.Ubuntu Git.Git Google.Chrome Google.PlatformTools `
               jqlang.jq M2Team.NanaZip Microsoft.Teams Microsoft.Office Microsoft.VisualStudioCode `
               OBSProject.OBSStudio okibcn.nano Starpine.Screenbox WinDirStat.WinDirStat `
               WinMerge.WinMerge

irm https://go.ponces.dev/caffeine | iex
irm https://go.ponces.dev/chezmoi | iex
irm https://go.ponces.dev/mise | iex
irm https://go.ponces.dev/mpv | iex
irm https://go.ponces.dev/pwsh | iex
irm https://go.ponces.dev/surfshark | iex

New-Item -Path "$env:APPDATA/apktool" -ItemType Directory -Force | Out-Null
curl -sfSL https://go.ponces.dev/apktool -o "$env:APPDATA/apktool/apktool.ps1"

if (-not (Test-Path $PROFILE)) {
    New-Item $PROFILE -Type File -ErrorAction Stop -Force | Out-Null
}
Add-Content -Path $PROFILE -Value "function sshcode() { code --remote ssh-remote+ponces@ubuild01.ponces.dev @Args }"
