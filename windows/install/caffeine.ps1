$ErrorActionPreference = 'Stop'

winget install ZhornSoftware.Caffeine

$ShortcutPath = "$env:APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/Caffeine.lnk"
$Shortcut = (New-Object -COMObject WScript.Shell).CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = (Get-Command caffeine64).Source
$Shortcut.Arguments = "-startoff -stes"
$Shortcut.Save()
