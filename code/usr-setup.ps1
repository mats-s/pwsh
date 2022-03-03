# Usage:
# .\CreateUserCSV.ps1
# will create the csv-file which can be used like this (if enterprise.uss domain prepared):
# $ADUsers = Import-Csv enterpriseussusers.csv -Delimiter ";"
# # Headers: Username;GivenName;SurName;UserPrincipalName;DisplayName;Password;Department;Path
# foreach ($User in $ADUsers) {
#     New-ADUser `
#     -SamAccountName        $User.Username `
#     -UserPrincipalName     $User.UserPrincipalName `
#     -Name                  $User.DisplayName `
#     -GivenName             $User.GivenName `
#     -Surname               $User.SurName `
#     -Enabled               $True `
#     -ChangePasswordAtLogon $False `
#     -DisplayName           $user.Displayname `
#     -Department            $user.Department `
#     -Path                  $user.path `
#     -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force)
# }
# Note: might get "The password does not meet the length, complexity, or
# history requirement of the domain." due to bad default password policy

# Run this script to create your own list of 100 users for the enterprise.uss
# infrastructure as a CSV-file
# Each time the script is run, it will create a new random combination
# of firstname (which is also the username), lastname and department
# New unique random passwords are generated for every user

# Test so we don't overwrite a file by accident
#
if ((Get-ChildItem -ErrorAction SilentlyContinue enterpriseussusers.csv).Exists)
  {"You alread have the file enterpriseussusers.csv!"; return;}

# 100 unique firstnames without norwegian characters ('øæå')
#
$FirstName = @("Nora","Emma","Ella","Maja","Olivia","Emilie","Sofie","Leah",
               "Sofia","Ingrid","Frida","Sara","Tiril","Selma","Ada","Hedda",
               "Amalie","Anna","Alma","Eva","Mia","Thea","Live","Ida","Astrid",
               "Ellinor","Vilde","Linnea","Iben","Aurora","Mathilde","Jenny",
               "Tuva","Julie","Oda","Sigrid","Amanda","Lilly","Hedvig",
               "Victoria","Amelia","Josefine","Agnes","Solveig","Saga","Marie",
               "Eline","Oline","Maria","Hege","Jakob","Emil","Noah","Oliver",
               "Filip","William","Lucas","Liam","Henrik","Oskar","Aksel",
               "Theodor","Elias","Kasper","Magnus","Johannes","Isak","Mathias",
               "Tobias","Olav","Sander","Haakon","Jonas","Ludvig","Benjamin",
               "Matheo","AlfScience","Alexander","Victor","Markus","Theo",
               "Mohammad","Herman","Adam","Ulrik","Iver","Sebastian","Johan",
               "Odin","Leon","Nikolai","Even","Leo","Kristian","Mikkel",
               "Gustav","Felix","Sverre","Adrian","Lars"
              )

# 100 unique lastnames
#
$LastName = @("Hansen","Johansen","Olsen","Larsen","Andersen","Pedersen",
              "Nilsen","Kristiansen","Jensen","Karlsen","Johnsen","Pettersen",
              "Eriksen","Berg","Haugen","Hagen","Johannessen","Andreassen",
              "Jacobsen","Dahl","Jørgensen","Henriksen","Lund","Halvorsen",
              "Sørensen","Jakobsen","Moen","Gundersen","Iversen","Strand",
              "Solberg","Svendsen","Eide","Knutsen","Martinsen","Paulsen",
              "Bakken","Kristoffersen","Mathisen","Lie","Amundsen","Nguyen",
              "Rasmussen","Ali","Lunde","Solheim","Berge","Moe","Nygård",
              "Bakke","Kristensen","FScienceriksen","Holm","Lien","Hauge",
              "Christensen","Andresen","Nielsen","Knudsen","Evensen","Sæther",
              "Aas","Myhre","Hanssen","Ahmed","Haugland","Thomassen",
              "Sivertsen","Simonsen","Danielsen","Berntsen","Sandvik",
              "Rønning","Arnesen","Antonsen","Næss","Vik","Haug","Ellingsen",
              "Thorsen","Edvardsen","Birkeland","Isaksen","Gulbrandsen","Ruud",
              "Aasen","Strøm","Myklebust","Tangen","Ødegård","Eliassen",
              "Helland","Bøe","Jenssen","Aune","Mikkelsen","Tveit","Brekke",
              "Abrahamsen","Madsen"
             )

# 2 in IT, 8 in Adm and 30 consultants in each of in each of Operations, Science and Command
#
$OrgUnits = @("ou=HR,ou=AllUsers","ou=HR,ou=AllUsers",
              "ou=Adm,ou=AllUsers","ou=Adm,ou=AllUsers","ou=Adm,ou=AllUsers",
              "ou=Adm,ou=AllUsers","ou=Adm,ou=AllUsers","ou=Adm,ou=AllUsers",
              "ou=Adm,ou=AllUsers","ou=Adm,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Operations,ou=Cons,ou=AllUsers","ou=Operations,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Science,ou=Cons,ou=AllUsers","ou=Science,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers",
              "ou=Command,ou=Cons,ou=AllUsers","ou=Command,ou=Cons,ou=AllUsers"
             )

# Three shuffled indices to randomly mix firstname, lastname, and department
#
$fnidx = 0..99 | Get-Random -Shuffle
$lnidx = 0..99 | Get-Random -Shuffle
$ouidx = 0..99 | Get-Random -Shuffle

Write-Output "GivenName;UserName;SurName;UserPrincipalName;DisplayName;Password;Department;Path" > enterpriseussusers.csv

foreach ($i in 0..99) {
  $GivenName         = $FirstName[$fnidx[$i]]
  $UserName          = $GivenName[0].ToLower() + $SurName.ToLower()
  $SurName           = $LastName[$lnidx[$i]]
  $UserPrincipalName = $UserName + '@' + 'enterprise.uss'
  $DisplayName       = $GivenName + ' ' + $SurName
  $Password          = -join ('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPRSTUVWXYZ0123456789!"#$%&()*+,-./:<=>?@[\]_{|}'.ToCharArray() | Get-Random -Count 16)
  $Department        = ($OrgUnits[$ouidx[$i]] -split '[=,]')[1]
  $Path              = $OrgUnits[$ouidx[$i]] + ',' + "dc=enterprise,dc=uss"
  Write-Output "$GivenName;$UserName;$SurName;$UserPrincipalName;$DisplayName;$Password;$Department;$Path" >> enterpriseussusers.csv
}