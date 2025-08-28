# Get-ChildItem -Path "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs" -File -Name > "$HOME\Documents\GitHub\ScriptsDiversos\lifeIntSec.txt"

$pasta = "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
$exclude = Get-Content "$HOME\Documents\GitHub\ScriptsDiversos\lifeIntSec.txt"
$origin = Get-ChildItem -Path $pasta -File -Name
$finalList = Compare-Object $origin $exclude -PassThru

$backup = "$HOME\Backup"
if (!(Test-Path -Path $backup)) {
    Start-Sleep -Seconds 1
    New-Item -Path $pasta -Name Backup -ItemType Directory
    Start-Sleep -Seconds 2
}

# Set-Location $pasta
# Atalhos do menu iniciar
$finalList | ForEach-Object -Process {
    Move-Item -Path "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\$_" -Destination $backup
}
Start-Sleep -Seconds 2

# Caminho completo
"$HOME\Videos\h.xspf",
"$HOME\Videos\H",
"$HOME\Documents\Games" | ForEach-Object -Process {
    Set-ItemProperty -Path "$_" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden -bor [System.IO.FileAttributes]::System)
}