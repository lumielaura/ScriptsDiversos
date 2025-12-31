# Como Usar
# .\BuscaArquivos.ps1 -PastaBase "C:\MeuDiretorio" -Palavras "relatório", "2023", "final"

# Dados mandatorios para usar script
param (
    [Parameter(Mandatory=$true)]
    [string]$PastaBase,

    [Parameter(Mandatory=$true)]
    [string[]]$Palavras
)

# Verificando se a pasta descrita existe
if (-not (Test-Path $PastaBase)) {
    Write-Host "A pasta especificada '$PastaBase' não existe." -ForegroundColor Red
    exit
}

# Informando na tela do usuario as informações que ele passou
Write-Host "Procurando arquivos na pasta '$PastaBase' contendo: $($Palavras -join ', ')" -ForegroundColor Cyan

# Procura recursiva por arquivos
$arquivosEncontrados = Get-ChildItem -Path $PastaBase -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
    $arquivo = $_.Name.ToLower()
    foreach ($palavra in $Palavras) {
        if ($arquivo -like "*$($palavra.ToLower())*") {
            return $true
        }
    }
    return $false
}

if ($arquivosEncontrados.Count -eq 0) {
    Write-Host "Nenhum arquivo encontrado com as palavras-chave fornecidas." -ForegroundColor Yellow
} else {
    Write-Host "`nArquivos encontrados:`n" -ForegroundColor Green
    $arquivosEncontrados | ForEach-Object { Write-Host $_.FullName && "" }
}
