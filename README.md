# BringBackChromeExtensions

PowerShell script that enables Chrome's Manifest V2 enterprise policy on Chrome 138 and older.

> This project is archived. Chrome removed the policy flag in version 139, so the script cannot restore Manifest V2 on newer releases.

## What it changes

The script creates this machine-wide registry value:

```text
HKLM\SOFTWARE\Policies\Google\Chrome
ExtensionManifestV2Availability = 2 (DWORD)
```

Administrator access is required because the value is stored under `HKEY_LOCAL_MACHINE`. The script checks the installed Chrome version, writes the policy, and verifies the saved value.

## Run it

1. Download [EnableMV2.ps1](EnableMV2.ps1) and review it.
2. Open PowerShell as Administrator in the download folder.
3. Run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\EnableMV2.ps1
```

Restart Chrome, then open `chrome://policy` and confirm that `ExtensionManifestV2Availability` is set to `2`.

## Undo it

Run this in PowerShell as Administrator:

```powershell
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Google\Chrome' -Name 'ExtensionManifestV2Availability'
```

Restart Chrome after removing the policy.

## Support

The repository is kept as a reference and is no longer maintained. New issues will not be handled.
