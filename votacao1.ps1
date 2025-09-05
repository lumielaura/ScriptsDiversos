# Script: Votação dinâmica com log, gráfico colorido e candidatos de arquivo

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

# Caminho dos arquivos
$arquivoCandidatos = Join-Path $PSScriptRoot "votacaoCandidatos.txt"
$logPath = Join-Path $PSScriptRoot "votacao_log.txt"

# Verifica se o arquivo de candidatos existe
if (-not (Test-Path $arquivoCandidatos)) {
    Write-Host "Arquivo 'votacaoCandidatos.txt' não encontrado!" -ForegroundColor Red
    Write-Host "Crie um arquivo 'votacaoCandidatos.txt' no mesmo diretório, com um candidato por linha."
    exit
}

# Lê candidatos do arquivo
$candidatos = Get-Content $arquivoCandidatos | Where-Object { $_.Trim() -ne "" }
if ($candidatos.Count -eq 0) {
    Write-Host "O arquivo 'votacaoCandidatos.txt' está vazio!" -ForegroundColor Red
    exit
}

# Inicializa lista de participantes
$participantes = @()
foreach ($nome in $candidatos) {
    $participantes += @{ Nome = $nome; Votos = 0 }
}

# Cria ou limpa o log no início
"===== Início da Votação $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss') =====" | Out-File -FilePath $logPath

function MostrarVotos {
    Clear-Host
    Write-Host "===== Votação em andamento =====" -ForegroundColor Cyan
    $contador = 1
    foreach ($p in $participantes) {
        Write-Host ("{0}. {1,-20}: {2}" -f $contador, $p.Nome, $p.Votos)
        $contador++
    }
    Write-Host "------------------------------------"
    Write-Host "Digite o número do candidato (1-$($participantes.Count)) para votar."
    Write-Host "Digite 'fim' para encerrar a votação."
}

# Loop de votação
while ($true) {
    MostrarVotos
    $entrada = Read-Host "Seu voto"

    if ($entrada -eq "fim") {
        break
    }

    if ($entrada -match "^[0-9]+$" -and [int]$entrada -ge 1 -and [int]$entrada -le $participantes.Count) {
        $indice = [int]$entrada - 1
        $participantes[$indice].Votos++

        # Registrar no log
        $linha = "$(Get-Date -Format 'dd/MM/yyyy HH:mm:ss') - Voto para: $($participantes[$indice].Nome)"
        Add-Content -Path $logPath -Value $linha
    } else {
        Write-Host "Entrada inválida. Digite um número válido ou 'fim'." -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
}

# Exibir resultado final no console
Clear-Host
Write-Host "===== Resultado Final =====" -ForegroundColor Yellow
foreach ($p in $participantes) {
    Write-Host ("{0,-20}: {1}" -f $p.Nome, $p.Votos)
}

# Determinar vencedor
$maxVotos = ($participantes | Measure-Object Votos -Maximum).Maximum
$vencedores = $participantes | Where-Object { $_.Votos -eq $maxVotos }

# Garantir que $vencedores seja um array
$vencedores = @($participantes | Where-Object { $_.Votos -eq $maxVotos })

if ($vencedores.Count -gt 1) {
    Write-Host "Houve um empate entre:" -ForegroundColor Magenta
    $vencedores | ForEach-Object { Write-Host $_.Nome }

    $nomesEmpate = ($vencedores | ForEach-Object { $_.Nome }) -join ', '
    Add-Content -Path $logPath -Value "Resultado: Empate entre $nomesEmpate"
}
else {
    $nomeVencedor = $vencedores[0].Nome
    Write-Host "O vencedor é: $nomeVencedor" -ForegroundColor Green
    Add-Content -Path $logPath -Value "Resultado: Vencedor - $nomeVencedor"
}


Add-Content -Path $logPath -Value "===== Fim da Votação $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss') ====="

# Criar gráfico de barras colorido
$form = New-Object Windows.Forms.Form
$form.Text = "Resultado da Votação"
$form.Width = 800
$form.Height = 600

$chart = New-Object Windows.Forms.DataVisualization.Charting.Chart
$chart.Width = 750
$chart.Height = 500
$chart.Left = 20
$chart.Top = 20

$chartArea = New-Object Windows.Forms.DataVisualization.Charting.ChartArea
$chart.ChartAreas.Add($chartArea)

$series = New-Object Windows.Forms.DataVisualization.Charting.Series
$series.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Bar

# Paleta de cores
$colors = [System.Drawing.Color[]] @(
    "Red", "Blue", "Green", "Orange", "Purple", "Brown", "Teal", "Pink", "Gray", "Gold"
)

for ($i = 0; $i -lt $participantes.Count; $i++) {
    $p = $participantes[$i]
    $point = $series.Points.AddXY($p.Nome, $p.Votos)
    $series.Points[$i].Color = $colors[$i % $colors.Count]  # Reutiliza cores se tiver mais candidatos que cores
}

$chart.Series.Add($series)
$form.Controls.Add($chart)

$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
