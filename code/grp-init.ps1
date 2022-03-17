# Oppretter grupper i AD.

# Hasher options for global og domain local grupper og lager gruppene
$RDPGroup = @{
    Name           = "g_My RDP Users"
    GroupCategory  = "Security"
    GroupScope     = "Global"
    SamAccountName = "g_MyRDPUsers"
    DisplayName    = "RDP Users"
    Path           = "OU=Groups,DC=enterprise,DC=uss"
    Description    = "Admin accounts who will be able to RDP to other clients/servers"
}
$admGroup = @{
    Name           = "g_My Adm Users"
    GroupCategory  = "Security"
    GroupScope     = "Global"
    SamAccountName = "g_MyAdmUsers"
    DisplayName    = "Admin Users"
    Path           = "OU=Groups,DC=enterprise,DC=uss"
    Description    = "Group for all admins"
}
$FullWallGroup = @{
    Name           = "dl_My Wallpaper FullAccess"
    GroupCategory  = "Security"
    GroupScope     = "DomainLocal"
    SamAccountName = "dl_MyWallpaperFullAccess"
    DisplayName    = "WallpaperShare FullAccess"
    Path           = "OU=Groups,DC=enterprise,DC=uss"
    Description    = "Used for full access to C:\WallpaperShare"
}
$ReadWallGroup = @{
    Name           = "dl_My Wallpaper ReadAccess"
    GroupCategory  = "Security"
    GroupScope     = "DomainLocal"
    SamAccountName = "dl_MyWallpaperReadAccess"
    DisplayName    = "WallpaperShare ReadAccess"
    Path           = "OU=Groups,DC=enterprise,DC=uss"
    Description    = "Used for read access to C:\WallpaperShare"
}
New-ADGroup @RDPGroup
New-ADGroup @admGroup
New-ADGroup @FullWallGroup
New-ADGroup @ReadWallGroup

# I folge AGDLP gjor Global group medlem av Domain Local access permission
Add-ADGroupMember -Identity 'dl_MyWallpaperReadAccess' -Members 'Domain Users'
Add-ADGroupMember -Identity 'dl_MyWallpaperFullAccess' -Members 'g_MyAdmUsers'

# Dynamisk gruppe allokering av Adm OUen
$Admins = (Get-ADUser -Filter * -SearchBase 'OU=Adm,OU=AllUsers,DC=enterprise,DC=uss').SamAccountName
foreach ($u in $Admins.Split()) {
    Add-ADGroupMember -Identity 'g_MyRDPUsers' -Members $u
    Add-ADGroupMember -Identity 'g_MyAdmUsers' -Members $u
}

# SMB share for wallpapers
New-Item -ItemType Directory C:\WallpaperShare
curl "https://raw.githubusercontent.com/mats-s/pwsh/main/galaxy.jpg" -o "C:\WallpaperShare\galaxy.jpg"
New-SmbShare -Name "Wallpapers" -Path "C:\WallpaperShare"
# I folge AGDLP setter permission til en Domain Local group
Grant-SmbShareAccess -Name Wallpapers -AccountName "USS\dl_MyWallpaperReadAccess" -AccessRight Read -Force
Grant-SmbShareAccess -Name Wallpapers -AccountName "USS\dl_MyWallpaperFullAccess" -AccessRight Full -Force