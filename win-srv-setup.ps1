#cd:
cd C:\Users\Admin

#Språk:
Get-WinUserLanguageList
Set-WinUserLanguageList -LanguageList nb-NO

#Choco install
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y powershell-core

#Sysinternals install:
choco install -y sysinternals

#BgInfo setup:
Invoke-WebRequest "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip" -OutFile ".\LGPO.zip"  
Expand-Archive .\LGPO.zip -DestinationPath LGPO
cd .\LGPO\LGPO_30
Invoke-WebRequest "https://folk.ntnu.no/erikhje/mylgpo-13012022.zip" -OutFile ".\mylgpo-13012022.zip"  
Expand-Archive .\mylgpo-13012022.zip -DestinationPath mylgpo
.\LGPO.exe /g 'C:\Users\Admin\LGPO\LGPO_30\mylgpo\'
Invoke-WebRequest "https://github.com/mats-s/quick-setup/blob/main/mats-info.bgi" -OutFile "C:\ProgramData\chocolatey\lib\sysinternals\tools\mats-info.bgi"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Admin\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Bginfo.lnk")
$Shortcut.TargetPath = "C:\ProgramData\chocolatey\lib\sysinternals\tools\Bginfo.exe"
$Shortcut.Arguments = "/silent /nocliprompt /timer:0"
$Shortcut.Save()

#pwsh.exe theme:
#For å se de forskjellige themesa man kan velge mellom > https://github.com/lukesampson/concfg/tree/master/preset_examples 
cd C:\Users\Admin
Invoke-WebRequest "https://codeload.github.com/lukesampson/concfg/zip/refs/heads/master" -OutFile ".\master.zip"
Expand-Archive .\master.zip -DestinationPath concfg
.\concfg\concfg-master\bin\concfg.ps1 import dracula -y
pwsh.exe

#Litt moro:
Start-Process "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
