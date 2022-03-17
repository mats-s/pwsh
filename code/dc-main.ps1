# Hovedscript for domenekontroller.

# Funksjon for at passord-generering skal gaa gjennom PSScriptanalyzer
function ScriptFix() {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
    param()

    ConvertTo-SecureString $user.Password -AsPlainText -Force
}


Try {
    Write-Output "`nLager OU'er...`n"

    # Danner User OU's
    New-ADOrganizationalUnit 'AllUsers' -Description 'Containing OUs and users'
    New-ADOrganizationalUnit 'HR' -Description 'Human Resources' -Path 'OU=AllUsers,DC=enterprise,DC=uss'
    New-ADOrganizationalUnit 'Cons' -Description 'Consultants' -Path 'OU=AllUsers,DC=enterprise,DC=uss'
    New-ADOrganizationalUnit 'Adm' -Description 'Administration' -Path 'OU=AllUsers,DC=enterprise,DC=uss'
    New-ADOrganizationalUnit 'Command' -Description 'IT team' -Path 'OU=Cons,OU=AllUsers,DC=enterprise,DC=uss'
    New-ADOrganizationalUnit 'Science' -Description 'Engineering team' -Path 'OU=Cons,OU=AllUsers,DC=enterprise,DC=uss'
    New-ADOrganizationalUnit 'Operations' -Description 'Economics team'-Path 'OU=Cons,OU=AllUsers,DC=enterprise,DC=uss'
    New-ADOrganizationalUnit 'Groups' -Description 'All groups' -Path 'DC=enterprise,DC=uss'

    # Danner Computer OU's
    New-ADOrganizationalUnit 'Machines' -Description 'Containing Servers, management and client machines'
    New-ADOrganizationalUnit 'Clients' -Description 'Containing OUs and users laptops' -Path 'OU=Machines,DC=enterprise,DC=uss'
    New-ADOrganizationalUnit 'Servers' -Description 'Containing OUs and servers' -Path 'OU=Machines,DC=enterprise,DC=uss'
    New-ADOrganizationalUnit 'Management' -Description 'Containing management laptops' -Path 'OU=Machines,DC=enterprise,DC=uss'
    New-ADOrganizationalUnit 'Member Servers' -Description 'Containing OUs and servers' -Path 'OU=Servers,OU=Machines,DC=enterprise,DC=uss'
    New-ADOrganizationalUnit 'Domain Controllers' -Description 'Containing OUs and servers' -Path 'OU=Servers,OU=Machines,DC=enterprise,DC=uss'

    # Viser administrator hvilke OU'er som er opprettet.
    Get-ADOrganizationalUnit -Filter * | Format-Table -Property Name, DistinguishedName

    # Legger til dc1 i riktig OU
    Move-ADObject -Identity 'CN=dc1,OU=Domain Controllers,DC=enterprise,DC=uss' -TargetPath 'OU=Domain Controllers,OU=Servers,OU=Machines,DC=enterprise,DC=uss'
} Catch { Write-Output "`nFeil i opprettelse av OU'er, gaar videre....`n" }

Try {
    # Danner brukere.
    .\usr-setup-csv.ps1
    $ADUsers = Import-Csv enterpriseussusers.csv -Delimiter ";"
    Write-Output "`nLager brukere...`n"
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
        -AccountPassword (ScriptFix)
    }
    # Viser administrator hvor mange brukere som ble opprettet.
    $antBrukere = (Get-ADUser -Filter * -SearchBase "OU=Allusers, DC=Enterprise, DC=USS").Count
    Write-Output "$antBrukere brukere ble opprettet."
} Catch { Write-Output "`nFeil i opprettelse av brukere, gaar videre`n"}

Try {
    Write-Output "`nLager GPO'er...`n"
    # Danner GPO'er.
    .\gpo-init.ps1

    # Viser administrator GPO'er som er opprettet.
    Get-GPO -All | Format-Table -Property DisplayName, DomainName
} Catch {Write-Output "`nFeil i opprettelse av GPO'er, gaar videre...`n"}

# Setter lokasjon for resten av scriptet i main
Set-Location C:\ScriptsAD
Try {
    Write-Output "`nLager grupper...`n"
    # Danner grupper.
    .\grp-init.ps1

    # Viser administrator gruppene som er opprettet.
    Get-ADGroup -Filter * -Properties * -SearchBase "OU=Groups, DC=Enterprise, DC=USS" |
    Format-Table -Property Name, GroupCategory, GroupScope, samAccountname, Description

    # Viser administrator tilganger for nylig opprettet SMB-Share.
    Get-SmbShareAccess -Name Wallpapers | Format-Table Name, AccountName,AccessControlType, AccessRight
} Catch { Write-Output "`nFeil i opprettelse av grupper/SMB-Share, gaar videre...`n" }


# Meny for brukeren med oppretting av maskiner.
do{
    Write-Output "`n#####################"
    $kommando = Read-Host "K - Ny klient`nS - Ny server`nM - Ny manager`nQ - Quit`nValg: "
}while ($kommando -ne 'K' -and $kommando -ne 'S' -and $kommando -ne 'M' -and $kommando -ne 'Q')

while ($kommando -ne 'Q'){
    # Legger til en klient (cl1) i domene og initerer til riktig OU vha New-PSSession
    if ($kommando -eq 'K') {

        $curValue = (Get-Item wsman:\localhost\Client\TrustedHosts).value
        $ip = Read-Host -Prompt 'Tast inn IP-addresse til klient'
        if ($curValue -eq '') {
            Set-Item wsman:\localhost\Client\TrustedHosts -Value "$ip"
        } else {
            Set-Item wsman:\localhost\Client\TrustedHosts -Value "$curValue, $ip"
        }

        $cred = Get-Credential -Username Admin -Message 'Passord for klient: '
        $connect = New-PSSession -Credential $cred $ip
        $dc1ip = (Get-NetIPAddress).IPv4Address[2]
        Invoke-Command -Session $connect {
        Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $Using:dc1ip
        $cred = Get-Credential -UserName 'USS\Administrator' -Message 'Cred for domenekontroller: '
        Add-Computer -Credential $cred -DomainName enterprise.uss `
        -OUPath 'OU=Clients,OU=Machines,DC=enterprise,DC=uss' -PassThru
        Write-Output "`nMaskinen restarter!`n"
        Restart-Computer -Force
        }
        Remove-PSSession $connect
        Get-ADComputer -Filter * |
        Select-Object -Property DNSHostName,DistinguishedName
    }

    # Legger til en server (srv1) i domene og initerer til riktig OU vha New-PSSession
    if ($kommando -eq 'S') {
        $curValue = (Get-Item wsman:\localhost\Client\TrustedHosts).value
        $ip1 = Read-Host -Prompt 'Tast inn IP-addresse til server'
        if ($curValue -eq '') {
            Set-Item wsman:\localhost\Client\TrustedHosts -Value "$ip1"
        } else {
            Set-Item wsman:\localhost\Client\TrustedHosts -Value "$curValue, $ip1"
        }

        $cred1 = Get-Credential -Username Admin -Message 'Passord for server: '
        $connect1 = New-PSSession -Credential $cred1 $ip1
        $dc1ip = (Get-NetIPAddress).IPv4Address[2]
        Invoke-Command -Session $connect1 {
        Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $Using:dc1ip
        $cred1 = Get-Credential -UserName 'USS\Administrator' -Message 'Passord for domenekontroller: '
        Add-Computer -Credential $cred1 -DomainName enterprise.uss `
        -OUPath 'OU=Member Servers,OU=Servers,OU=Machines,DC=enterprise,DC=uss' -PassThru
        Write-Output "`nMaskinen restarter!`n"
        Restart-Computer -Force
        }
        Remove-PSSession $connect1
        Get-ADComputer -Filter * |
        Select-Object -Property DNSHostName,DistinguishedName
    }

    # Legger til en manager (mgr) i domene og initerer til riktig OU vha New-PSSession
    if ($kommando -eq 'M') {
        $curValue = (Get-Item wsman:\localhost\Client\TrustedHosts).value
        $ip2 = Read-Host -Prompt 'Tast inn IP-addresse til manager'
        if ($curValue -eq '') {
            Set-Item wsman:\localhost\Client\TrustedHosts -Value "$ip2"
        } else {
            Set-Item wsman:\localhost\Client\TrustedHosts -Value "$curValue, $ip2"
        }

        $cred2 = Get-Credential -Username Admin -Message 'Passord for manager: '
        $connect2 = New-PSSession -Credential $cred2 $ip2
        $dc1ip = (Get-NetIPAddress).IPv4Address[2]
        Invoke-Command -Session $connect2 {
        Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $Using:dc1ip
        $cred2 = Get-Credential -UserName 'USS\Administrator' -Message 'Passord for domenekontroller: '
        Add-Computer -Credential $cred2 -DomainName enterprise.uss `
        -OUPath 'OU=Management,OU=Machines,DC=enterprise,DC=uss' -PassThru
        Write-Output "`nMaskinen restarter!`n"
        Restart-Computer -Force
        }
        Remove-PSSession $connect2
        Get-ADComputer -Filter * |
        Select-Object -Property DNSHostName,DistinguishedName
    }

    do{
        Write-Output "`n#####################"
        $kommando = Read-Host "K - Ny klient`nS - Ny server`nM - Ny manager`nQ - Quit`nValg: "
    }while ($kommando -ne 'K' -and $kommando -ne 'S' -and $kommando -ne 'M' -and $kommando -ne 'Q')
}