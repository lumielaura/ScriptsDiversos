$pasta = "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
$backup = "$HOME\Backup"

# Atalhos Iniciar
Get-ChildItem -Path $backup | ForEach-Object -Process {
    Move-Item -Path "$_" -Destination $pasta
}

# Caminho completo
# Arquivos
"$HOME\Videos\h.xspf" | ForEach-Object -Process {
    Set-ItemProperty -Path "$_" -Name Attributes -Value ([System.IO.FileAttributes]::Archive)
}

# Pastas
"$HOME\Videos\H",
"$HOME\Documents\Games" | ForEach-Object -Process {
    Set-ItemProperty -Path "$_" -Name Attributes -Value ([System.IO.FileAttributes]::Normal)
}

