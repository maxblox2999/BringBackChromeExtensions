#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
$isAdministrator = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdministrator) {
    throw 'Run this script as Administrator.'
}

$chromePaths = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
)

$chromePath = $chromePaths | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

if (-not $chromePath) {
    Write-Host 'Could not find a current installation of Chrome.' -ForegroundColor Yellow
    exit 0
}

$chromeVersion = [version](Get-Item -LiteralPath $chromePath).VersionInfo.ProductVersion

if ($chromeVersion.Major -ge 139) {
    Write-Host 'Chrome removed this flag in later versions.' -ForegroundColor Yellow
    exit 0
}

$policyPath = 'HKLM:\SOFTWARE\Policies\Google\Chrome'
$policyName = 'ExtensionManifestV2Availability'

New-Item -Path $policyPath -Force | Out-Null
New-ItemProperty -Path $policyPath -Name $policyName -Value 2 -PropertyType DWord -Force | Out-Null

$savedValue = Get-ItemPropertyValue -Path $policyPath -Name $policyName

if ($savedValue -ne 2) {
    throw "The policy write failed. Expected 2, found $savedValue."
}

Write-Host "Policy set for Chrome $chromeVersion. Restart Chrome, then check chrome://policy." -ForegroundColor Green
