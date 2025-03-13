If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) 
{	Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit	}

$ProgressPreference = 'SilentlyContinue'

$Path = $env:TEMP; $Installer = "DiscordSetup.exe"; Invoke-WebRequest "https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x64" -OutFile $Path\$Installer; Start-Process -FilePath $Path\$Installer -Args "-s" -Verb RunAs -Wait; Remove-Item $Path\$Installer

Copy-Item "C:\Users\$env:username\AppData\Local\Discord\app-*\installer.db" -Destination "C:\Users\$env:username\AppData\Local\Discord" -Force
Remove-Item "C:\Users\$env:username\Desktop\Discord.lnk" -Force
Remove-Item "C:\Users\$env:username\AppData\Local\Discord\SquirrelSetup.log" -Force
Remove-Item "C:\Users\$env:username\AppData\Roaming\discord\module_data\crashlogs\*" -Force
Move-Item -Path "C:\Users\$env:username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk" -Destination "C:\Users\$env:username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs" -Force
Remove-Item "C:\Users\$env:username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc" -Force
Reg.exe delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Discord" /f
Get-ChildItem -Path C:\Users\$env:username\AppData\Local\Discord\app-*\locales\ -exclude en-US.pak -Recurse | Remove-Item -Force -Recurse

$MultilineComment = @"
{
  "enableHardwareAcceleration": false,
  "OPEN_ON_STARTUP": false,
  "debugLogging": false,
  "openasar": {
    "setup": true,
    "noTyping": true
  }
}
"@
Set-Content -Path "$env:C:\Users\$env:username\AppData\Roaming\discord\settings.json" -Value $MultilineComment -Force

$destination = Get-ChildItem -Path "AppData\Local\Discord\*\resources"
$Path = $env:TEMP; $Installer = "app.asar"; Invoke-WebRequest "https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar" -OutFile $Path\$Installer; Move-Item AppData\Local\Temp\app.asar -Destination $destination -Force

exit