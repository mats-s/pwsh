#Her er main script for oppsett av dc, mgr, svr og cl

do{
    $kommando = Read-Host "(1)Lag OU, (2)Ny klient/server, (0)Quit: "
}while ($kommando -ne 1 -and $kommando -ne 2 -and $kommando -ne 0)
while ($kommando -ne 0){
    if($kommando -eq 1){
        Write-Output "`nLager OU`s...`n"
        # Danner User OU`s

        New-ADOrganizationalUnit 'AllUsers' -Description 'Containing OUs and users'
        New-ADOrganizationalUnit 'HR' -Description 'Human Resources' -Path 'OU=AllUsers,DC=enterprise,DC=uss'
        New-ADOrganizationalUnit 'Cons' -Description 'Consultants' -Path 'OU=AllUsers,DC=enterprise,DC=uss'
        New-ADOrganizationalUnit 'Adm' -Description 'Administration' -Path 'OU=AllUsers,DC=enterprise,DC=uss'
        New-ADOrganizationalUnit 'Command' -Description 'IT team' -Path 'OU=Cons,OU=AllUsers,DC=enterprise,DC=uss'
        New-ADOrganizationalUnit 'Science' -Description 'Engineering team' -Path 'OU=Cons,OU=AllUsers,DC=enterprise,DC=uss'
        New-ADOrganizationalUnit 'Operations' -Description 'Economics team'-Path 'OU=Cons,OU=AllUsers,DC=enterprise,DC=uss'


        # Danner Computer OU`s

        New-ADOrganizationalUnit 'Machines' -Description 'Containing Servers, management and client machines'
        New-ADOrganizationalUnit 'Clients' -Description 'Containing OUs and users laptops' -Path 'OU=Machines,DC=enterprise,DC=uss'
        New-ADOrganizationalUnit 'Servers' -Description 'Containing OUs and servers' -Path 'OU=Machines,DC=enterprise,DC=uss'
        New-ADOrganizationalUnit 'Management' -Description 'Containing management laptops' -Path 'OU=Machines,DC=enterprise,DC=uss'

        curl -O https://raw.githubusercontent.com/mats-s/pwsh/main/code/usr-setup-csv.ps1
        .\usr-setup-csv.ps1
        $ADUsers = Import-Csv enterpriseussusers.csv -Delimiter ";"
        foreach ($User in $ADUsers) {
            New-ADUser `
            -SamAccountName $User.Username `
            -UserPrincipalName $User.UserPrincipalName `
            -Name $User.DisplayName `
            -GivenName $User.GivenName `
            -Surname $User.SurName `
            -Enabled $True `
            -ChangePasswordAtLogon $False `
            -DisplayName $user.Displayname `
            -Department $user.Department `
            -Path $user.path `
            -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force)
        }



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
            Add-Computer -Credential $cred -DomainName enterprise.uss -OUPath 'OU=Servers,OU=Machines,DC=enterprise,DC=uss' -PassThru -Verbose
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
            Add-Computer -Credential $cred -DomainName enterprise.uss -OUPath 'OU=Management,OU=Machines,DC=enterprise,DC=uss' -PassThru -Verbose
            Get-ADComputer -Filter * |
            Select-Object -Property DNSHostName,DistinguishedName
        }

    }
    do{
        $kommando = Read-Host "(1)Sett OU, (2)Ny klient/Server, (0)Quit: "
    }while ($kommando -ne 1 -and $kommando -ne 2 -and $kommando -ne 0)
}