# Esconder arquivos
# gci -r $folder | % { $_.Attributes = $_.Attributes -bor "Hidden" }
# alternatively
Get-ChildItem -Recurse $folder | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }

# Ver arquivos novamente
# -force é necessario apenas para listar arquivos escondidos
# gci -r -fo $folder | % { $_.attributes -bor "Hidden" -bxor  "Hidden" }


# -----------------
# Para Pastas
# Set-ItemProperty -Path "$HOME\Documents\FTP" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden -bor [System.IO.FileAttributes]::System)
# Reverter operação
# Set-ItemProperty -Path "$HOME\Documents\FTP" -Name Attributes -Value ([System.IO.FileAttributes]::Normal)

# Para Arquivos - Atribui Hidden e System
# Set-ItemProperty -Path "caminho_do_arquivo" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden -bor [System.IO.FileAttributes]::System)
# Reverter operação - Atribui apenas Arquivo
# Set-ItemProperty -Path "caminho_do_arquivo" -Name Attributes -Value ([System.IO.FileAttributes]::Archive)

$pasta = "C:\Users\Anderson\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
$exclude = Get-Content "C:\Users\Anderson\Documents\GitHub\ScriptsDiversos\lifeIntSec.txt"
$origin = Get-ChildItem -Path $pasta -File -Name
$finalList = Compare-Object $origin $exclude -PassThru

# Ocultar
# Arquivos
"C:\Users\Anderson\Videos\h.xspf",
$finalList | ForEach-Object -Process {Set-ItemProperty -Path "$pasta\$_" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden -bor [System.IO.FileAttributes]::System)}

# Pastas
"C:\Users\Anderson\Videos\H",
"C:\Users\Anderson\Documents\Games" | ForEach-Object -Process {Set-ItemProperty -Path "$_" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden -bor [System.IO.FileAttributes]::System)}


# Mostrar
# Arquivos
"C:\Users\Anderson\Videos\h.xspf",
$finalList | ForEach-Object -Process {Set-ItemProperty -Path "$pasta\$_" -Name Attributes -Value ([System.IO.FileAttributes]::Archive)}

# Pastas
"C:\Users\Anderson\Videos\H",
"C:\Users\Anderson\Documents\Games" | ForEach-Object -Process {Set-ItemProperty -Path "$_" -Name Attributes -Value ([System.IO.FileAttributes]::Normal)}

# -----------------
