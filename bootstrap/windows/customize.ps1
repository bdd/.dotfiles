## TODO: Black Background
Add-Type -typedefinition "using System;`n using System.Runtime.InteropServices;`n public class PInvoke { [DllImport(`"user32.dll`")] public static extern bool SetSysColors(int cElements, int[] lpaElements, int[] lpaRgbValues); }"
[PInvoke]::SetSysColors(1, @(1), @(0x000000))

## Caps Lock -> Ctrl
$hexes = "00,00,00,00,00,00,00,00,02,00,00,00,1d,00,3a,00,00,00,00,00".Split(',') | % { "0x$_"};
$kbl = 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout';
New-ItemProperty -Path $kbl "Scancode Map" -PropertyType Binary -Value ([byte[]]$hexes);

## Autohide Taskbar
$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
$v=(Get-ItemProperty -Path $p).Settings
$v[8]=3
&Set-ItemProperty -Path $p -Name Settings -Value $v
&Stop-Process -f -ProcessName explorer

## Touchpad
Set-ItemProperty -Type Dword  "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" "RightClickZoneEnabled" 0
Set-ItemProperty -Type Dword "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" "ThreeFingerTapEnabled" 0
Set-ItemProperty -Type Dword "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" "FourFingerTapEnabled" 0
