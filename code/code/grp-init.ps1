$GROUP = @{
    Name          = "g_RDP Users"
    GroupCategory = "Security"
    GroupScope    = "Global"
    DisplayName   = "Local RDP users"
    Path          = "OU=AllUsers,DC=enterpise,DC=uss"
    Description   = "Users that will be allowed to RDP"
  }
New-ADGroup @GROUP
$Admin = (Get-ADUser -Filter * -SearchBase "OU=Adm,OU=AllUsers,DC=enterpise,DC=uss").Name
Add-ADGroupMember -Identity 'g_RDP Users' -Members $Admin
Get-ADGroupMember -Identity 'g_RDP Users'