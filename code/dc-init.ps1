Set-Location C:\Users\Admin
Get-WinUserLanguageList
Set-WinUserLanguageList -LanguageList nb-NO
Set-TimeZone -Id "W. Europe Standard Time" -PassThru

# Choco install og pwsh-core:
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y powershell-core
choco install -y sysinternals

# ADDS rolle:
# Kjor som administrator
Install-WindowsFeature AD-Domain-Services, DNS -IncludeManagementTools
$Password = Read-Host -Prompt 'Enter Password' -AsSecureString
Set-LocalUser -Password $Password Administrator
$Params = @{
    DomainMode                    = 'WinThreshold'
    DomainName                    = 'enterprise.uss'
    DomainNetbiosName             = 'USS'
    ForestMode                    = 'WinThreshold'
    InstallDns                    = $true
    NoRebootOnCompletion          = $true
    SafeModeAdministratorPassword = $Password
    Force                         = $true
}
Install-ADDSForest @Params
Restart-Computer