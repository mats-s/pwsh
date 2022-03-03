Invoke-WebRequest "https://gitlab.stud.idi.ntnu.no/api/v4/projects/15168/repository/files/code%2Fdc-init.ps1?ref=main" -Headers @{"Authorization"="token glpat-f4qz2DpANdDrLdzKbx_T"} -OutFile ~\dc-init.ps1
curl --header "PRIVATE-TOKEN: glpat-f4qz2DpANdDrLdzKbx_T" "https://gitlab.stud.idi.ntnu.no/api/v4/projects/15168/repository/files/code%2Fdc-init.ps1?ref=master"


curl https://gitlab.stud.idi.ntnu.no/api/v4/projects?private_token=glpat-f4qz2DpANdDrLdzKbx_T

curl https://gitlab.stud.idi.ntnu.no/api/v4/projects/15168/repository/tree?private_token=glpat-f4qz2DpANdDrLdzKbx_T

curl https://gitlab.stud.idi.ntnu.no/api/v4/projects/15168/repository/raw_blobs/<file_id>?private_token=<your_private_token>


