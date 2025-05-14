# Como usar >> & $HOME\Documents\GitHub\ScriptsDiversos\removerDuplicados.ps1 "C:\Pasta1" "D:\Pasta2"

param(
    [Parameter(Mandatory = $true)]
    [string]$folder1,

    [Parameter(Mandatory = $true)]
    [string]$folder2
)

# Verifica se as pastas existem
if (-not (Test-Path $folder1)) {
    Write-Host "❌ A pasta 1 não existe: $folder1"
    exit
}
if (-not (Test-Path $folder2)) {
    Write-Host "❌ A pasta 2 não existe: $folder2"
    exit
}

# Função para obter hash MD5
function Get-FileHashString {
    param([string]$path)
    return (Get-FileHash -Path $path -Algorithm MD5).Hash
}

# Função para mover para a lixeira
function Move-ToRecycleBin {
    param([string]$filePath)
    Add-Type -AssemblyName Microsoft.VisualBasic
    [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile(
        $filePath,
        'OnlyErrorDialogs',
        'SendToRecycleBin'
    )
}

# Obter arquivos
$files1 = Get-ChildItem -Path $folder1 -File | Select-Object Name, FullName
$files2 = Get-ChildItem -Path $folder2 -File | Select-Object Name, FullName

# Arquivos com nomes duplicados
$duplicateNames = Compare-Object -ReferenceObject $files1.Name -DifferenceObject $files2.Name -IncludeEqual -ExcludeDifferent |
Where-Object { $_.SideIndicator -eq "==" } |
Select-Object -ExpandProperty InputObject

# Verificar se encontrou duplicatas
if ($duplicateNames.Count -eq 0) {
    Write-Host "Nenhum arquivo com nome repetido foi encontrado."
    return
}

# Iterar sobre os arquivos duplicados e perguntar qual deletar
foreach ($name in $duplicateNames) {
    $file1 = ($files1 | Where-Object { $_.Name -eq $name })[0]
    $file2 = ($files2 | Where-Object { $_.Name -eq $name })[0]

    $hash1 = Get-FileHashString $file1.FullName
    $hash2 = Get-FileHashString $file2.FullName

    Write-Host "`nArquivo duplicado: $name"
    Write-Host "1 - $($file1.FullName)"
    Write-Host "2 - $($file2.FullName)"

    if ($hash1 -eq $hash2) {
        Write-Host "🟢 Os arquivos são idênticos (mesmo conteúdo)."
    } else {
        Write-Host "🔴 Os arquivos têm conteúdos diferentes!"
    }

    $choice = Read-Host "Deseja enviar qual versão para a lixeira? (1 / 2 / n para ignorar)"

    switch ($choice) {
        "1" {
            Move-ToRecycleBin $file1.FullName
            Write-Host "Arquivo da Pasta 1 movido para a lixeira."
        }
        "2" {
            Move-ToRecycleBin $file2.FullName
            Write-Host "Arquivo da Pasta 2 movido para a lixeira."
        }
        default {
            Write-Host "Arquivo mantido."
        }
    }
}
