$ApktoolDownloadUrl = "https://api.github.com/repos/iBotPeaches/Apktool/releases/latest"

function Invoke-Apktool {
    $env:PATH_BASE = if ($env:PATH_BASE) { $env:PATH_BASE } else { $env:PATH }
    $env:PATH = "$PWD;$env:PATH_BASE"
    & java -jar "$PSScriptRoot\\apktool.jar" @args
}

function Get-Apktool {
    try {
        $asset = (Invoke-RestMethod -Uri $ApktoolDownloadUrl -UseBasicParsing).assets | Where-Object { $_.name -match "apktool_([\d.]+)\.jar" }
        if ($asset) {
            $downloadUrl = $asset.browser_download_url
            $outputPath = "$PSScriptRoot\\apktool.jar"
            Invoke-WebRequest -Uri $downloadUrl -OutFile $outputPath -UseBasicParsing
        } else {
            Write-Error "Could not find the apktool.jar asset in the latest release."
        }
    } catch {
        Write-Error "Failed to retrieve the latest version from GitHub or download apktool.jar: $_"
    }
}

if (Test-Path -Path "$PSScriptRoot\\apktool.jar") {
    if ($args[0] -eq "--update") {
        $currentVersion = Invoke-Apktool --version
        $latestVersion = (Invoke-RestMethod -Uri $ApktoolDownloadUrl -UseBasicParsing).tag_name.TrimStart('v')
        if ($currentVersion -ne $latestVersion) {
            Write-Host "Updating apktool.jar from $currentVersion to $latestVersion..."
            Get-Apktool
        } else {
            Write-Host "apktool is already up-to-date."
        }
    } else {
        Invoke-Apktool @args
    }
} else {
    Get-Apktool
    Invoke-Apktool @args
}
