# Caminho do arquivo de entrada
$arquivoNomes = "$PSScriptRoot\nomes2.txt"

# Verifica se o arquivo existe
if (-not (Test-Path $arquivoNomes)) {
    Write-Host "Arquivo 'nomes.txt' não encontrado em: $PSScriptRoot" -ForegroundColor Red
    exit
}

# Lê os nomes do arquivo, ignorando linhas em branco
$pessoas = Get-Content $arquivoNomes | Where-Object { $_.Trim() -ne "" }

if ($pessoas.Count -lt 2) {
    Write-Host "É necessário pelo menos 2 pessoas para o torneio." -ForegroundColor Red
    exit
}

# Embaralha a lista de participantes
$pessoas = $pessoas | Sort-Object { Get-Random }

# Mostra participantes iniciais
Write-Host "`n==== PARTICIPANTES ====" -ForegroundColor Cyan
$pessoas | ForEach-Object { Write-Host " - $_" }

# Prepara arquivo de saída
$saida = "$PSScriptRoot\resultado_torneio_pessoas.txt"
"" | Out-File $saida
Add-Content $saida "==== TORNEIO ENTRE PESSOAS ===="

$pessoas | ForEach-Object { Add-Content $saida " - $_" }

# Histórico para o diagrama
$historico = @()

# Início do torneio
Write-Host "`n==== INÍCIO DO TORNEIO ====" -ForegroundColor Yellow
Add-Content $saida "`n==== INÍCIO DO TORNEIO ===="

$rodada = 1
while ($pessoas.Count -gt 1) {
    Write-Host "`n--- Rodada $rodada ---" -ForegroundColor Magenta
    Add-Content $saida "`n--- Rodada $rodada ---"

    $vencedores = @()
    $i = 0
    while ($i -lt $pessoas.Count) {
        if ($i -eq $pessoas.Count - 1) {
            Write-Host "`n$($pessoas[$i]) avança automaticamente para a próxima fase!"
            Add-Content $saida "`n$($pessoas[$i]) avançou automaticamente para a próxima fase."
            $vencedores += $pessoas[$i]
            $historico += [PSCustomObject]@{ Rodada=$rodada; P1=$pessoas[$i]; P2="---"; Vencedor=$pessoas[$i] }
        } else {
            # Mostra confronto
            Write-Host "`nConfronto:" -ForegroundColor Cyan
            Write-Host "1) $($pessoas[$i])"
            Write-Host "2) $($pessoas[$i+1])"

            # Pergunta vencedor
            do {
                $escolha = Read-Host "`nQuem venceu? (1 ou 2)"
            } while ($escolha -notin @("1","2"))

            if ($escolha -eq "1") {
                $vencedores += $pessoas[$i]
                Write-Host "✅ $($pessoas[$i]) venceu!" -ForegroundColor Green
                Add-Content $saida "$($pessoas[$i]) venceu contra $($pessoas[$i+1])"
                $historico += [PSCustomObject]@{ Rodada=$rodada; P1=$pessoas[$i]; P2=$pessoas[$i+1]; Vencedor=$pessoas[$i] }
            } else {
                $vencedores += $pessoas[$i+1]
                Write-Host "✅ $($pessoas[$i+1]) venceu!" -ForegroundColor Green
                Add-Content $saida "$($pessoas[$i+1]) venceu contra $($pessoas[$i])"
                $historico += [PSCustomObject]@{ Rodada=$rodada; P1=$pessoas[$i]; P2=$pessoas[$i+1]; Vencedor=$pessoas[$i+1] }
            }
        }
        $i += 2
    }
    $pessoas = $vencedores
    $rodada++
}

# Campeão final
Write-Host "`n=== CAMPEÃO DO TORNEIO ===" -ForegroundColor Yellow
$campeao = $pessoas[0]
Write-Host "🏆 $campeao 🏆" -ForegroundColor Cyan

Add-Content $saida "`n=== CAMPEÃO DO TORNEIO ==="
Add-Content $saida "🏆 $campeao 🏆"

# === Gerar diagrama visual ===
Write-Host "`n==== DIAGRAMA DO TORNEIO ====" -ForegroundColor Yellow
Add-Content $saida "`n==== DIAGRAMA DO TORNEIO ===="

# Descobre o tamanho do maior nome
$tamanhoMax = ($historico | ForEach-Object { @($_.P1, $_.P2, $_.Vencedor) } | Measure-Object -Maximum Length).Maximum

foreach ($r in ($historico | Group-Object Rodada)) {
    Write-Host "`nRodada $($r.Name):" -ForegroundColor Cyan
    Add-Content $saida "`nRodada $($r.Name):"

    foreach ($match in $r.Group) {
        if ($match.P2 -eq "---") {
            $linha = ("{0,-$tamanhoMax}" -f $match.P1) + " ──► (avanço automático)"
            Write-Host $linha
            Add-Content $saida $linha
        } else {
            $p1 = "{0,-$tamanhoMax}" -f $match.P1
            $p2 = "{0,-$tamanhoMax}" -f $match.P2
            $v  = "{0,-$tamanhoMax}" -f $match.Vencedor

            $linha1 = "$p1 ──╮"
            $linha2 = (" " * ($tamanhoMax + 1)) + "├─► $v"
            $linha3 = "$p2 ──╯"

            Write-Host $linha1
            Write-Host $linha2
            Write-Host $linha3

            Add-Content $saida $linha1
            Add-Content $saida $linha2
            Add-Content $saida $linha3
        }
    }
}


Write-Host "`nResultado final salvo em: $saida" -ForegroundColor Green
