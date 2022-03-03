# Oppsett av cl1, mgr og srv1
# Ma utfores pa begge maskinene.

Set-Location C:\Users\Admin
Get-WinUserLanguageList
Set-WinUserLanguageList -LanguageList nb-NO


# Setter domene for aktuell bruker
# Finn en god losning på IP via new-PSsession (fra dc1 til srv1,cl1,mgr)
#$ip = Read-Host -Prompt 'Tast inn IP-addresse til domenekontroller'
#Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $ip
#$cred = Get-Credential -UserName 'enterprise\Administrator' -Message 'Cred'
#Add-Computer -Credential $cred -DomainName enterprise.uss -PassThru -Verbose
#Restart-Computer

# Apner for Enter-PSSession sånn at vi kan gjøre mest mulig fra domenekontroller
New-ItemProperty -Name LocalAccountTokenFilterPolicy `
  -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System `
  -PropertyType DWord -Value 1

  # Gjor Get-SMBShare på DC1    


