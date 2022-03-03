# Oppsett av cl1, mgr og srv1
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

# Apner for Enter-PSSession sånn at vi kan gjøre mest mulig fra domenekontroller
New-ItemProperty -Name LocalAccountTokenFilterPolicy `
  -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System `
  -PropertyType DWord -Value 1