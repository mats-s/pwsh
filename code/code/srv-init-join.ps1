#Koble til host utenfor domene:

# Ser om andre "trusted hosts" eksistrerer sa vi ikke overskriver
# Spor deretter om IP-adresse og creds for server/klient den vil koble til.
$curValue = (Get-Item wsman:\localhost\Client\TrustedHosts).value
$ip = Read-Host -Prompt 'Tast inn IP-addresse til klient/server'
if ($curValue -eq '') {
  Set-Item wsman:\localhost\Client\TrustedHosts -Value $ip
} else {
  Set-Item wsman:\localhost\Client\TrustedHosts -Value "$curValue, $ip"
}
$cred = Get-Credential -Username Admin -Message 'Cred'
Enter-PSSession -Credential $cred $ip