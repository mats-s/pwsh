# Alle kommandoer vi bruker for aa hente scripts.

# Henter og pakker ut zip-fil med alt vi trenger paa dc-main
curl "https://raw.githubusercontent.com/mats-s/pwsh/main/ScriptsAD.zip" -o "C:\ScriptsAD.zip"
Expand-Archive C:\ScriptsAD.zip -DestinationPath C:\ScriptsAD

# Henter init-scripts for cl1 og mgr
curl -O "https://raw.githubusercontent.com/mats-s/pwsh/main/code/cl-mgr-init-join.ps1"
.\cl-mgr-init-join.ps1

# Henter init-scripts for srv1
curl -O "https://raw.githubusercontent.com/mats-s/pwsh/main/code/srv-init-join.ps1"
.\srv-init-join.ps1
