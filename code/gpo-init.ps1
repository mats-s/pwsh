# Fjerner GPO linken i AD og sletter den fordi vi har importert vaar egen versjon av denne.
$USS = "DC=enterprise,DC=uss"
Remove-GPLink -Name "Default Domain Policy" -Target $USS
Rename-GPO -Name  "Default Domain Policy" -TargetName "Old Default Domain Policy"

Set-Location C:\ScriptsAD\GPO\

$GPO = "C:\ScriptsAD\GPO\"
# Dynmaisk allokering av navn og ID pa GPO
$nr = 0
$gpoDir = Get-ChildItem | Where-Object{$_.PSISContainer}
  foreach ($d in $gpoDir) {
      $dir = (Get-ChildItem | Select-Object -Index $nr).Name
      [xml]$Data = Get-Content ".\$dir\bkupInfo.xml"
      $Navn = ($data.BackupInst.GPODisplayName)."#cdata-section"
      $ID = ($data.BackupInst.ID)."#cdata-section"
      New-GPO $Navn
      Import-GPO -Backupid $ID -TargetName $Navn -Path $GPO
      $nr+=1
}


# Setter OU paths, baade for ryddig struktur og hvis vi skal bruke dem flere ganger.
$CL = "OU=Clients,OU=Machines,DC=enterprise,DC=uss"
$DC = "OU=Domain Controllers,OU=Servers,OU=Machines,DC=enterprise,DC=uss"
$SRV = "OU=Member Servers,OU=Servers,OU=Machines,DC=enterprise,DC=uss"
$MCH = "OU=Machines,DC=enterprise,DC=uss"
$AUSER = "OU=AllUsers,DC=enterprise,DC=uss"
$ADM = "OU=Adm,OU=AllUsers,DC=enterprise,DC=uss"

# Linker GPOer til OUer
Get-GPO -Name "Default Domain Policy" | New-GPLink -Target $USS
Get-GPO -Name "MSFT Windows Server 2022 - Member Server" | New-GPLink -Target $SRV
Get-GPO -Name "MSFT Windows Server 2022 - Domain Controller" | New-GPLink -Target $DC
Get-GPO -Name "Machine Audit" | New-GPLink -Target $MCH
Get-GPO -Name "User Restrictions" | New-GPLink -Target $AUSER
Get-GPO -Name "Computer Restrictions" | New-GPLink -Target $CL
Get-GPO -Name "Admin Privileges" | New-GPLink -Target $ADM
