# Script: Placar em tempo real da votação (tabela com cores + barras)
$arquivoCandidatos = Join-Path $PSScriptRoot "votacaoCandidatos.txt"
$logPath = Join-Path $PSScriptRoot "votacao_log.txt"

if (-not (Test-Path $arquivoCandidatos)) {
    Write-Host "Arquivo 'votacaoCandidatos.txt' não encontrado!" -ForegroundColor Red
    exit
}

$candidatos = Get-Content $arquivoCandidatos | Where-Object { $_.Trim() -ne "" }
if ($candidatos.Count -eq 0) {
    Write-Host "O arquivo 'votacaoCandidatos.txt' está vazio!" -ForegroundColor Red
    exit
}

# Inicializa contagem de votos
$placar = @{}
foreach ($c in $candidatos) { $placar[$c] = 0 }

Write-Host "📡 Monitorando votos em tempo real... (CTRL + C para sair)" -ForegroundColor Cyan
Write-Host ""

# Função para desenhar barra de progresso
function Get-Bar($valor, $max, $largura=20) {
    if ($max -eq 0) { return "" }
    $filled = [math]::Round(($valor / $max) * $largura)
    return ("█" * $filled) + (" " * ($largura - $filled))
}

# Lê log continuamente
Get-Content -Path $logPath -Wait | ForEach-Object {
    $linha = $_
    if ($linha -match "Voto para: (.+)$") {
        $nome = $matches[1]
        if ($placar.ContainsKey($nome)) {
            $placar[$nome]++
        }
    }

    # Atualiza tela
    Clear-Host
    Write-Host "===== 📊 Placar Atual =====" -ForegroundColor Yellow

    $ordenado = $placar.GetEnumerator() | Sort-Object Value -Descending
    $maxVotos = ($ordenado | Select-Object -First 1).Value
    $minVotos = ($ordenado | Select-Object -Last 1).Value

    foreach ($p in $ordenado) {
        $barra = Get-Bar $p.Value $maxVotos 25

        if ($p.Value -eq $maxVotos -and $maxVotos -ne $minVotos) {
            Write-Host ("{0,-15}: {1,3} |{2}|" -f $p.Key, $p.Value, $barra) -ForegroundColor Green
        }
        elseif ($p.Value -eq $minVotos -and $maxVotos -ne $minVotos) {
            Write-Host ("{0,-15}: {1,3} |{2}|" -f $p.Key, $p.Value, $barra) -ForegroundColor Red
        }
        else {
            Write-Host ("{0,-15}: {1,3} |{2}|" -f $p.Key, $p.Value, $barra) -ForegroundColor White
        }
    }

    Write-Host "==========================="
}
