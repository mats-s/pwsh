# Opprettelse av brukere

if ((Get-ChildItem -ErrorAction SilentlyContinue enterpriseussusers.csv).Exists)
  {"Du har allerede filen: enterpriseussusers.csv!"; return;}

# 100 unike norske fornavn.
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
               "Matheo","Alfred","Alexander","Victor","Markus","Theo",
               "Mohammad","Herman","Adam","Ulrik","Iver","Sebastian","Johan",
               "Odin","Leon","Nikolai","Even","Leo","Kristian","Mikkel",
               "Gustav","Felix","Sverre","Adrian","Lars"
              )

# 100 unike norske etternavn
$LastName = @("Hansen","Johansen","Olsen","Larsen","Andersen","Pedersen",
              "Nilsen","Kristiansen","Jensen","Karlsen","Johnsen","Pettersen",
              "Eriksen","Berg","Haugen","Hagen","Johannessen","Andreassen",
              "Jacobsen","Dahl","Jorgensen","Henriksen","Lund","Halvorsen",
              "Sorensen","Jakobsen","Moen","Gundersen","Iversen","Strand",
              "Solberg","Svendsen","Eide","Knutsen","Martinsen","Paulsen",
              "Bakken","Kristoffersen","Mathisen","Lie","Amundsen","Nguyen",
              "Rasmussen","Ali","Lunde","Solheim","Berge","Moe","Nygaard",
              "Bakke","Kristensen","Fredriksen","Holm","Lien","Hauge",
              "Christensen","Andresen","Nielsen","Knudsen","Evensen","Saether",
              "Aas","Myhre","Hanssen","Ahmed","Haugland","Thomassen",
              "Sivertsen","Simonsen","Danielsen","Berntsen","Sandvik",
              "Ronning","Arnesen","Antonsen","Naess","Vik","Haug","Ellingsen",
              "Thorsen","Edvardsen","Birkeland","Isaksen","Gulbrandsen","Ruud",
              "Aasen","Strom","Myklebust","Tangen","Odegaard","Eliassen",
              "Helland","Boe","Jenssen","Aune","Mikkelsen","Tveit","Brekke",
              "Abrahamsen","Madsen"
             )

# 2 i 'HR', 8 i 'Adm' og 30 konsulenter i hver av 'Operations', 'Science' og 'Command'.
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

# Mikser navn, etternavn og OU'er.
$fnidx = 0..99 | Get-Random -Shuffle
$lnidx = 0..99 | Get-Random -Shuffle
$ouidx = 0..99 | Get-Random -Shuffle

Write-Output "GivenName;UserName;SurName;UserPrincipalName;DisplayName;Password;Department;Path" > enterpriseussusers.csv

# Funskjon for a lage passord der de inneholder alle typer tegn som er norm i gode og sikre passord.
function RandomPassword {
  [CmdletBinding()]
  # Parametere
  Param(
      [Parameter()]
      [int]$PasswordLength = 16,
      [Parameter()]
      [switch]$BigLetters,
      [Parameter()]
      [switch]$SmallLetters,
      [Parameter()]
      [switch]$Numbers,
      [Parameter()]
      [switch]$NormalSpecials
  )
      $asciiTable = $null
      # Sjekker om parametere er angitt.
      if (!$BigLetters -and !$SmallLetters -and !$Numbers -and !$NormalSpecials) {
          for ( $i = 97; $i -le 122; $i++ ) {
              $asciiTable += , [char][byte]$i
          }
      }
      if ($Numbers) {
          for ( $i = 48; $i -le 57; $i++ ) {
              $asciiTable += , [char]$i
          }
      }

      if ($NormalSpecials) {
          $asciiTable += "*","$","-","+","?","_","&","=","!","%","{","}","/"
      }
      if ($BigLetters) {
          for ( $i = 65; $i -le 90; $i++ ) {
              $asciiTable += , [char]$i
          }
      }
      if ($SmallLetters) {
          for ( $i = 97; $i -le 122; $i++ ) {
              $asciiTable += , [char]$i
          }
      }
      $tempPassword = $null
      for ( $i = 1; $i -le $PasswordLength; $i++) {
          $tempPassword += ( Get-Random -InputObject $asciiTable )
      }
      return $tempPassword
    }

# Oppretter brukere og legger dem i en fil.
foreach ($i in 0..99) {
  $GivenName         = $FirstName[$fnidx[$i]]
  $SurName           = $LastName[$lnidx[$i]]
  $UserName          = $GivenName + $SurName
  $UserPrincipalName = $UserName + '@' + 'enterprise.uss'
  $DisplayName       = $GivenName + ' ' + $SurName
  $Password          = RandomPassword -BigLetters -SmallLetters -Numbers -NormalSpecials
  $Department        = ($OrgUnits[$ouidx[$i]] -split '[=,]')[1]
  $Path              = $OrgUnits[$ouidx[$i]] + ',' + "dc=enterprise,dc=uss"
  Write-Output "$GivenName;$UserName;$SurName;$UserPrincipalName;$DisplayName;$Password;$Department;$Path" >> enterpriseussusers.csv
}

