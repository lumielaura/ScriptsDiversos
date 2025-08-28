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

# Cria os grupos com nome fixo
$grupos = @()
for ($i = 0; $i -lt $quantidadeGrupos; $i++) {
    $grupos += [PSCustomObject]@{
        Nome    = "Grupo $($i+1)"
        Membros = @()
    }
}

# Distribui os nomes nos grupos
$contador = 0
foreach ($nome in $nomes) {
    $indice = $contador % $quantidadeGrupos
    $grupos[$indice].Membros += $nome
    $contador++
}

# Mostra os grupos iniciais
foreach ($g in $grupos) {
    Write-Host "`n$($g.Nome) (Total: $($g.Membros.Count) pessoas):" -ForegroundColor Cyan
    $g.Membros | ForEach-Object { Write-Host " - $_" }
}

# Prepara arquivo de saída
$saida = "$PSScriptRoot\resultado_torneio.txt"
"" | Out-File $saida
Add-Content $saida "==== TORNEIO ENTRE GRUPOS ===="

foreach ($g in $grupos) {
    Add-Content $saida "`n$($g.Nome) (Total: $($g.Membros.Count) pessoas):"
    $g.Membros | ForEach-Object { Add-Content $saida " - $_" }
}

# Histórico para o diagrama
$historico = @()

# Início do torneio
Write-Host "`n==== INÍCIO DO TORNEIO ====" -ForegroundColor Yellow
Add-Content $saida "`n==== INÍCIO DO TORNEIO ===="

$rodada = 1
while ($grupos.Count -gt 1) {
    Write-Host "`n--- Rodada $rodada ---" -ForegroundColor Magenta
    Add-Content $saida "`n--- Rodada $rodada ---"

    $vencedores = @()
    $i = 0
    while ($i -lt $grupos.Count) {
        if ($i -eq $grupos.Count - 1) {
            Write-Host "`n$($grupos[$i].Nome) avança automaticamente para a próxima fase!"
            Add-Content $saida "`n$($grupos[$i].Nome) avançou automaticamente para a próxima fase."
            $vencedores += $grupos[$i]
            $historico += [PSCustomObject]@{ Rodada=$rodada; G1=$grupos[$i].Nome; G2="---"; Vencedor=$grupos[$i].Nome }
        } else {
            # Mostra confronto
            Write-Host "`nConfronto:" -ForegroundColor Cyan
            Write-Host "1) $($grupos[$i].Nome) (Total: $($grupos[$i].Membros.Count))"
            $grupos[$i].Membros | ForEach-Object { Write-Host "   - $_" }

            Write-Host ""
            Write-Host "2) $($grupos[$i+1].Nome) (Total: $($grupos[$i+1].Membros.Count))"
            $grupos[$i+1].Membros | ForEach-Object { Write-Host "   - $_" }

            # Pergunta vencedor
            do {
                $escolha = Read-Host "`nQual grupo venceu? (1 ou 2)"
            } while ($escolha -notin @("1","2"))

            if ($escolha -eq "1") {
                $vencedores += $grupos[$i]
                Write-Host "✅ $($grupos[$i].Nome) venceu!" -ForegroundColor Green
                Add-Content $saida "$($grupos[$i].Nome) venceu contra $($grupos[$i+1].Nome)"
                $historico += [PSCustomObject]@{ Rodada=$rodada; G1=$grupos[$i].Nome; G2=$grupos[$i+1].Nome; Vencedor=$grupos[$i].Nome }
            } else {
                $vencedores += $grupos[$i+1]
                Write-Host "✅ $($grupos[$i+1].Nome) venceu!" -ForegroundColor Green
                Add-Content $saida "$($grupos[$i+1].Nome) venceu contra $($grupos[$i].Nome)"
                $historico += [PSCustomObject]@{ Rodada=$rodada; G1=$grupos[$i].Nome; G2=$grupos[$i+1].Nome; Vencedor=$grupos[$i+1].Nome }
            }
        }
        $i += 2
    }
    $grupos = $vencedores
    $rodada++
}

# Campeão final
Write-Host "`n=== CAMPEÃO DO TORNEIO ===" -ForegroundColor Yellow
$campeao = $grupos[0]
Write-Host "$($campeao.Nome) (Total: $($campeao.Membros.Count) pessoas):" -ForegroundColor Cyan
$campeao.Membros | ForEach-Object { Write-Host " - $_" }

Add-Content $saida "`n=== CAMPEÃO DO TORNEIO ==="
Add-Content $saida "$($campeao.Nome) (Total: $($campeao.Membros.Count) pessoas):"
$campeao.Membros | ForEach-Object { Add-Content $saida " - $_" }

# === Gerar diagrama visual ===
Write-Host "`n==== DIAGRAMA DO TORNEIO ====" -ForegroundColor Yellow
Add-Content $saida "`n==== DIAGRAMA DO TORNEIO ===="

foreach ($r in ($historico | Group-Object Rodada)) {
    Write-Host "`nRodada $($r.Name):" -ForegroundColor Cyan
    Add-Content $saida "`nRodada $($r.Name):"
    foreach ($match in $r.Group) {
        if ($match.G2 -eq "---") {
            Write-Host "$($match.G1) ──► (avanço automático)"
            Add-Content $saida "$($match.G1) ──► (avanço automático)"
        } else {
            $linha1 = "$($match.G1) ──╮"
            $linha2 = "           ├─► $($match.Vencedor)"
            $linha3 = "$($match.G2) ──╯"
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
