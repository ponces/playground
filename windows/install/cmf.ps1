# Stop at first error
$ErrorActionPreference = 'Stop'

winget install AgileBits.1Password dbeaver.dbeaver Docker.DockerCLI Docker.DockerCompose `
               Fortinet.FortiClientVPN Hashicorp.Vagrant Microsoft.DotNet.SDK.3_1 `
               Microsoft.DotNet.SDK.6 Microsoft.DotNet.SDK.8 Microsoft.Teams `
               Microsoft.VisualStudioCode

setx ClientConfiguration__SecurityPortalBaseAddress "https://portalqa.criticalmanufacturing.dev/SecurityPortal/"
setx ClientConfiguration__ClientTenantName "CustomerPortalQA"
setx ClientConfiguration__HostAddress "portalqa.criticalmanufacturing.dev:443"
