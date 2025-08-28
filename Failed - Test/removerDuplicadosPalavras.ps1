param(
    [Parameter(Mandatory = $true)]
    [string]$folder1,

    [Parameter(Mandatory = $true)]
    [string]$folder2
)

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

# Função para contar palavras no nome (sem extensão)
function Get-WordCount {
    param([string]$fileName)
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    $words = $baseName -split '[-_\s]'
    return ($words | Where-Object { $_.Trim() -ne "" }).Count
}

# Obter arquivos de ambas as pastas
$files1 = Get-ChildItem -Path $folder1 -File
$files2 = Get-ChildItem -Path $folder2 -File

# Filtrar apenas nomes com mais de 2 palavras
$filtered1 = $files1 | Where-Object { Get-WordCount $_.Name -gt 2 }
$filtered2 = $files2 | Where-Object { Get-WordCount $_.Name -gt 2 }

# Criar hashset de nomes com 3+ palavras em ambas as pastas
$names1 = $filtered1.Name
$names2 = $filtered2.Name

# Identificar nomes repetidos com 3+ palavras
$commonNames = $names1 | Where-Object { $names2 -contains $_ }

if ($commonNames.Count -eq 0) {
    Write-Host "✅ Nenhum nome com mais de duas palavras repetido entre as duas pastas."
    exit
}

# Mostrar cada par e permitir escolha
foreach ($name in $commonNames) {
    $file1 = ($filtered1 | Where-Object { $_.Name -eq $name })[0]
    $file2 = ($filtered2 | Where-Object { $_.Name -eq $name })[0]

    Write-Host "`n🔁 Arquivo com nome repetido (3+ palavras):"
    Write-Host "1 - $($file1.FullName)"
    Write-Host "2 - $($file2.FullName)"

    $choice = Read-Host "Deseja mover qual versão para a lixeira? (1 / 2 / n para manter ambos)"

    switch ($choice) {
        "1" {
            Move-ToRecycleBin $file1.FullName
            Write-Host "✅ Arquivo da Pasta 1 enviado para a lixeira."
        }
        "2" {
            Move-ToRecycleBin $file2.FullName
            Write-Host "✅ Arquivo da Pasta 2 enviado para a lixeira."
        }
        default {
            Write-Host "⏭️ Arquivos mantidos."
        }
    }
}
