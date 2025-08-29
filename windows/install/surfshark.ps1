$ErrorActionPreference = 'Stop'

$path = 'HKLM:\SYSTEM\CurrentControlSet\Services\RasMan\Parameters'
New-ItemProperty -Path $path -Name "NegotiateDH2048_AES256" -PropertyType "DWORD" -Value "2"

curl -sfSL https://my.surfshark.com/vpn/p_api/v1/server/configurations/ikev2 -o $env:TMP/surfshark.crt
Import-Certificate -FilePath $env:TMP/surfshark.crt -CertStoreLocation cert:\LocalMachine\Root

Add-VpnConnection -Name Surfshark -ServerAddress "pt-opo.prod.surfshark.com" -RememberCredential
