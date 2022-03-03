# Danner User OU`s

New-ADOrganizationalUnit 'AllUsers' -Description 'Containing OUs and users'
New-ADOrganizationalUnit 'HR' -Description 'Human Resources' `
  -Path 'OU=AllUsers,DC=enterprise,DC=uss'
New-ADOrganizationalUnit 'Cons' -Description 'Consultants' `
  -Path 'OU=AllUsers,DC=enterprise,DC=uss'
New-ADOrganizationalUnit 'Adm' -Description 'Administration' `
  -Path 'OU=AllUsers,DC=enterprise,DC=uss'
New-ADOrganizationalUnit 'Command' -Description 'IT team' `
  -Path 'OU=Cons,OU=AllUsers,DC=enterprise,DC=uss'
New-ADOrganizationalUnit 'Science' -Description 'Engineering team' `
  -Path 'OU=Cons,OU=AllUsers,DC=enterprice,DC=uss'
New-ADOrganizationalUnit 'Operations' -Description 'Economics team' `
  -Path 'OU=Cons,OU=AllUsers,DC=enterprise,DC=uss'


# Danner Computer OU`s

New-ADOrganizationalUnit 'Machines' -Description 'Containing Servers, management and client machines'
New-ADOrganizationalUnit 'Clients' -Description 'Containing OUs and users laptops' -Path 'OU=Machines,DC=enterprise,DC=uss'
New-ADOrganizationalUnit 'Servers' -Description 'Containing OUs and servers' -Path 'OU=Machines,DC=enterprise,DC=uss'
New-ADOrganizationalUnit 'Management' -Description 'Containing management laptops' -Path 'OU=Machines,DC=enterprise,DC=uss'

New-ADOrganizationalUnit 'Clients' -Description 'Containing OUs and users laptops'
New-ADOrganizationalUnit 'Servers' -Description 'Containing OUs and servers'
New-ADOrganizationalUnit 'Adm' -Description 'Adm laptops' `
  -Path 'OU=Clients,DC=enterprise,DC=uss'
New-ADOrganizationalUnit 'Cons' -Description 'Consultants laptops' `
  -Path 'OU=Clients,DC=enterprise,DC=uss'


