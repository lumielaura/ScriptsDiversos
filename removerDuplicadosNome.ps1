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

# Obter listas de arquivos (nome apenas, sem caminho completo)
$files1 = Get-ChildItem -Path $folder1 -File -Recurse | Select-Object Name, FullName
$files2 = Get-ChildItem -Path $folder2 -File -Recurse | Select-Object Name, FullName

# Encontrar arquivos com nomes repetidos
$duplicateNames = Compare-Object -ReferenceObject $files1.Name -DifferenceObject $files2.Name -IncludeEqual -ExcludeDifferent |
Where-Object { $_.SideIndicator -eq "==" } |
Select-Object -ExpandProperty InputObject

# Verificar se encontrou duplicatas
if ($duplicateNames.Count -eq 0) {
    Write-Host "Nenhum arquivo com nome repetido foi encontrado entre as duas pastas."
    return
}

# Iterar sobre os arquivos duplicados e perguntar qual deletar
foreach ($name in $duplicateNames) {
    $file1 = $files1 | Where-Object { $_.Name -eq $name } | Select-Object -First 1
    $file2 = $files2 | Where-Object { $_.Name -eq $name } | Select-Object -First 1

    Write-Host "`nArquivo duplicado encontrado: $name"
    Write-Host "1 - $($file1.FullName)"
    Write-Host "2 - $($file2.FullName)"
    $choice = Read-Host "Deseja deletar qual versão? (1 / 2 / n para pular)"

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
            Write-Host "Arquivo ignorado."
        }
    }
}
