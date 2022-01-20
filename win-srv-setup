#URL template: 
https://gitlab.com/erikhje/heat-mono/-/raw/master/single_windows_server.yaml

#Språk:
Get-WinUserLanguageList
Set-WinUserLanguageList -LanguageList nb-NO

#Choco install
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y powershell-core
exit

#Sysinternals
choco install -y sysinternals

#BgInfo:
curl -O https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip
Expand-Archive .\LGPO.zip -DestinationPath LGPO
cd .\LGPO\LGPO_30
curl -O https://folk.ntnu.no/erikhje/mylgpo-13012022.zip
Expand-Archive .\mylgpo-13012022.zip -DestinationPath mylgpo
.\LGPO.exe /g 'C:\Users\Admin\LGPO\LGPO_30\mylgpo\'

#pwsh theme:
curl -O https://codeload.github.com/lukesampson/concfg/zip/refs/heads/master
Expand-Archive .\master -DestinationPath concfg
.\concfg\concfg-master\bin\concfg.ps1 import dracula -y
