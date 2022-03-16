# Oppsett av servere, altsaa srv1 i vaart tilfelle.
Set-Location C:\Users\Admin
Get-WinUserLanguageList
Set-WinUserLanguageList -LanguageList nb-NO
Set-TimeZone -Id "W. Europe Standard Time" -PassThru
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sCountry -Value "Norway";
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sLongDate -Value "dddd, d. MMMM yyyy";
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sShortDate -Value "dd.MM.yyyy";
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sShortTime -Value "HH:mm";
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sTimeFormat -Value "HH:mm:ss";
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sYearMonth -Value "MMMM yyyy";
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name iFirstDayOfWeek -Value 0;

# Laster ned choco install, pwsh-core og 7zip.
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-WebRequest -Uri https://chocolatey.org/install.ps1 -OutFile C:\Users\Admin\install.ps1
./install.ps1
choco install -y powershell-core
choco install -y sysinternals
choco install -y 7zip

# Setter bgi konfigurasjon og lager en batch for startup
curl "https://raw.githubusercontent.com/mats-s/pwsh/main/bgiconfig.bgi" -o "C:\ProgramData\chocolatey\lib\sysinternals\tools\bgiconfig.bgi"
Copy-Item "C:\ProgramData\chocolatey\lib\sysinternals\tools\bgiconfig.bgi" "C:\Users\$env:UserName\Desktop\bgiconfig.bgi"
& 'C:\ProgramData\chocolatey\lib\sysinternals\tools\Bginfo.exe' 'C:\ProgramData\chocolatey\lib\sysinternals\tools\bgiconfig.bgi'
Write-Output "start C:\ProgramData\chocolatey\lib\sysinternals\tools\Bginfo.exe C:\ProgramData\chocolatey\lib\sysinternals\tools\bgiconfig.bgi" > "C:\\Users\\Admin\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\bginfo.bat"

# Aapner for New-PSSession sann at vi kan gjore mest mulig fra domenekontroller
New-ItemProperty -Name LocalAccountTokenFilterPolicy `
  -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System `
  -PropertyType DWord -Value 1