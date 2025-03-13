If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) 
{	Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit	}

iex "& { $(iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -confirm_uninstall_ms_spoti -confirm_spoti_recomended_uninstall -podcasts_off -adsections_off -block_update_on -lyrics_stat purple -old_lyrics -cache_limit 500 -no_shortcut -DisableStartup"

Remove-Item "C:\Users\$env:username\AppData\Roaming\Spotify\Spotify.bak"
Remove-Item "C:\Users\$env:username\AppData\Roaming\Spotify\locales\*" -Exclude en-US.pak

$MultilineComment = @"
app.last-launched-version=
app.autostart-configured=true
app.autostart-mode="off"
ui.hardware_acceleration=false
network.proxy.mode=1
campaign-id=
core.clock_delta=
autologin.saved_credentials=
autologin.username=
autologin.canonical_username=
autologin.blob=
"@
Set-Content -Path "$env:C:\Users\$env:username\AppData\Roaming\Spotify\prefs" -Value $MultilineComment -Force

exit