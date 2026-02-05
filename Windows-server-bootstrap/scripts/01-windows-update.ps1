Write-Host "Installing Windows Updates..." -ForegroundColor Cyan

# ------------------------------------------------
# TLS + networking bootstrap
# ------------------------------------------------
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
} catch {}

# ------------------------------------------------
# Ensure PackageManagement + NuGet provider exist
# ------------------------------------------------
function Ensure-NuGetProvider {

    if (Get-PackageProvider -ListAvailable -Name NuGet -ErrorAction SilentlyContinue) {
        Write-Host "NuGet provider already installed."
        return
    }

    Write-Host "Bootstrapping NuGet provider..."

    $providerPath = "C:\Program Files\PackageManagement\ProviderAssemblies\NuGet"
    New-Item -ItemType Directory -Force -Path $providerPath | Out-Null

    try {
        add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@

        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

        $wc = New-Object System.Net.WebClient
        $url = "https://onegetcdn.azureedge.net/providers/Microsoft.PackageManagement.NuGetProvider-2.8.5.208.dll"
        $dest = "$providerPath\Microsoft.PackageManagement.NuGetProvider-2.8.5.208.dll"

        $wc.DownloadFile($url, $dest)

        Write-Host "NuGet provider installed (manual bootstrap)."
    }
    catch {
        Write-Warning "NuGet bootstrap failed."
        throw
    }
}

Ensure-NuGetProvider

Import-PackageProvider -Name NuGet -Force

# ------------------------------------------------
# Install PSWindowsUpdate module
# ------------------------------------------------
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Host "Installing PSWindowsUpdate module..."
    Install-Module PSWindowsUpdate -Force -SkipPublisherCheck
}

Import-Module PSWindowsUpdate

# ------------------------------------------------
# Run Windows Update
# ------------------------------------------------
Write-Host "Running Windows Update..."
Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot
