$ErrorActionPreference = 'Stop'

winget install Bitwarden.Bitwarden Canonical.Ubuntu Git.Git Google.Chrome Google.PlatformTools `
               jqlang.jq M2Team.NanaZip Microsoft.Teams Microsoft.Office Microsoft.VisualStudioCode `
               OBSProject.OBSStudio okibcn.nano Starpine.Screenbox WinDirStat.WinDirStat `
               WinMerge.WinMerge

irm https://go.ponces.dev/caffeine | iex
irm https://go.ponces.dev/chezmoiw | iex
irm https://go.ponces.dev/misew | iex
irm https://go.ponces.dev/mpv | iex
irm https://go.ponces.dev/pwsh | iex
irm https://go.ponces.dev/surfshark | iex

mise use --global gradle@8.6
mise use --global helm@latest
mise use --global helmfile@latest
mise use --global java@17
mise use --global kubectl@latest
mise use --global node@20
mise use --global oc@latest

mise activate pwsh | Out-String | Invoke-Expression

irm https://go.ponces.dev/androidw | iex

if (-not (Test-Path $PROFILE)) {
    New-Item $PROFILE -Type File -ErrorAction Stop -Force | Out-Null
}
Add-Content -Path $PROFILE -Value "mise activate pwsh | Out-String | Invoke-Expression"
Add-Content -Path $PROFILE -Value "function cgit() { cd `$env:USERPROFILE/Git }"
Add-Content -Path $PROFILE -Value "function cdown() { cd `$env:USERPROFILE/Downloads }"
Add-Content -Path $PROFILE -Value "function sshcode() { code --remote ssh-remote+ponces@ubuild01.ponces.dev @Args }"
