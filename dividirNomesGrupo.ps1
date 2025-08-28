# Caminho do arquivo de entrada
$arquivoNomes = "$PSScriptRoot\nomes.txt"

# Verifica se o arquivo existe
if (-not (Test-Path $arquivoNomes)) {
    Write-Host "Arquivo 'nomes.txt' não encontrado em: $PSScriptRoot" -ForegroundColor Red
    exit
}

# Lê os nomes do arquivo, ignorando linhas em branco
$nomes = Get-Content $arquivoNomes | Where-Object { $_.Trim() -ne "" }

if ($nomes.Count -eq 0) {
    Write-Host "O arquivo não contém nomes válidos." -ForegroundColor Red
    exit
}

# Pergunta a quantidade de grupos
do {
    $quantidadeGrupos = Read-Host "Digite a quantidade de grupos (mínimo 2)"
} while ($quantidadeGrupos -lt 2)

# Embaralha a lista de nomes
$nomes = $nomes | Sort-Object { Get-Random }

# Cria os grupos
$grupos = @()
for ($i = 0; $i -lt $quantidadeGrupos; $i++) {
    $grupos += ,@()
}

# Distribui os nomes de forma aleatória nos grupos
$contador = 0
foreach ($nome in $nomes) {
    $indice = $contador % $quantidadeGrupos
    $grupos[$indice] += $nome
    $contador++
}

# Mostra os resultados
for ($i = 0; $i -lt $quantidadeGrupos; $i++) {
    $total = $grupos[$i].Count
    Write-Host "`nGrupo $($i+1) (Total: $total pessoas):" -ForegroundColor Cyan
    $grupos[$i] | ForEach-Object { Write-Host " - $_" }
}

# (Opcional) salvar em arquivo
$saida = "$PSScriptRoot\resultado_grupos.txt"
"" | Out-File $saida
for ($i = 0; $i -lt $quantidadeGrupos; $i++) {
    $total = $grupos[$i].Count
    Add-Content $saida "`nGrupo $($i+1) (Total: $total pessoas):"
    $grupos[$i] | ForEach-Object { Add-Content $saida " - $_" }
}
Write-Host "`nResultado também salvo em: $saida" -ForegroundColor Green
