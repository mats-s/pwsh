# Oppsett av klienter, altsaa cl1 og mgr i vaart tilfelle.
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

# Aapner for New-PSSession sann at vi kan gjore mest mulig fra domenekontroller
Enable-PSRemoting -Force -SkipNetworkProfileCheck
