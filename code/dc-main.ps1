#Her er main script for oppsett av dc, mgr, svr og cl

do{
    $kommando = Read-Host "(1)Sett OU, (2)Ny klient/server, (0)Quit: "
}while ($kommando -ne 1 -and $kommando -ne 2 -and $kommando -ne 0)
while ($kommando -ne 0){
    if($kommando -eq 1){
        Write-Output "`nSetter OU`s...`n"
    }elseif($kommando -eq 2){
        Write-Output "`nStarter script for dannelse av Ny klient/server...`n"
        do {
        $valg = Read-Host -Prompt 'K(lient), S(erver) eller M(anager)'
        }while ($valg -ne 'K' -and $valg -ne 'S' -and $valg -ne 'M')

        if ($valg -eq 'K') {
            $curValue = (Get-Item wsman:\localhost\Client\TrustedHosts).value
            $ip = Read-Host -Prompt 'Tast inn IP-addresse til klient'
            if ($curValue -eq '') {
                Set-Item wsman:\localhost\Client\TrustedHosts -Value $ip
            } else {
            Set-Item wsman:\localhost\Client\TrustedHosts -Value "$curValue, $ip"

            }
            $cred = Get-Credential -Username Admin -Message 'Cred'
            Enter-PSSession -Credential $cred $ip
            Add-Computer -Credential $cred -DomainName enterprise.uss `
            -OUPath 'OU=Clients,OU=Machines,DC=enterprise,DC=uss' -PassThru -Verbose
            Get-ADComputer -Filter * |
            Select-Object -Property DNSHostName,DistinguishedName
        }
        if ($valg -eq 'S') {
            $curValue = (Get-Item wsman:\localhost\Client\TrustedHosts).value
            $ip = Read-Host -Prompt 'Tast inn IP-addresse til server'
            if ($curValue -eq '') {
                Set-Item wsman:\localhost\Client\TrustedHosts -Value $ip
            } else {
            Set-Item wsman:\localhost\Client\TrustedHosts -Value "$curValue, $ip"

            }
            $cred = Get-Credential -Username Admin -Message 'Cred'
            Enter-PSSession -Credential $cred $ip
            Add-Computer -Credential $cred -DomainName enterprise.uss `
            -OUPath 'OU=Servers,OU=Machines,DC=enterprise,DC=uss' -PassThru -Verbose
            Get-ADComputer -Filter * |
            Select-Object -Property DNSHostName,DistinguishedName
        }
        if ($valg -eq 'M') {
            $curValue = (Get-Item wsman:\localhost\Client\TrustedHosts).value
            $ip = Read-Host -Prompt 'Tast inn IP-addresse til manager'
            if ($curValue -eq '') {
                Set-Item wsman:\localhost\Client\TrustedHosts -Value $ip
            } else {
            Set-Item wsman:\localhost\Client\TrustedHosts -Value "$curValue, $ip"

            }
            $cred = Get-Credential -Username Admin -Message 'Cred'
            Enter-PSSession -Credential $cred $ip
            Add-Computer -Credential $cred -DomainName enterprise.uss `
            -OUPath 'OU=Management,OU=Machines,DC=enterprise,DC=uss' -PassThru -Verbose
            Get-ADComputer -Filter * |
            Select-Object -Property DNSHostName,DistinguishedName
        }

    }
    do{
        $kommando = Read-Host "(1)Sett OU, (2)Ny klient/Server, (0)Quit: "
    }while ($kommando -ne 1 -and $kommando -ne 2 -and $kommando -ne 0)
}