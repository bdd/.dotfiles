$disable = @(
    "Printing-XPSServices-Features"
    "WorkFolders-Client"
    "SmbDirect"
    "Internet-Explorer-Optional-amd64"
)

$enable = @(
    "Microsoft-Windows-Subsystem-Linux"
    "Containers-DisposableClientVM"
)

Write-Output "Disabling Windows Optional Features:"
foreach ($f in $disable) {
    Write-Output "$f"
    Disable-WindowsOptionalFeature -Online -FeatureName "$f" -NoRestart -Remove
}

Write-Output "Enabling Windows Optional Features:"
foreach ($f in $enable) {
    Write-Output "$f"
    Enable-WindowsOptionalFeature -Online -FeatureName "$f" -NoRestart -All
}
