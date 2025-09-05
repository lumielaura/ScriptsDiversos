# Script: Votação dinâmica com log, gráfico final (PNG) e candidatos de arquivo
# Votação com Placar

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

# Caminhos dos arquivos
$arquivoCandidatos = Join-Path $PSScriptRoot "votacaoCandidatos.txt"
$logPath = Join-Path $PSScriptRoot "votacao_log.txt"
$graficoPath = Join-Path $PSScriptRoot "grafico.png"

# Verifica se o arquivo de candidatos existe
if (-not (Test-Path $arquivoCandidatos)) {
    Write-Host "Arquivo 'votacaoCandidatos.txt' não encontrado!" -ForegroundColor Red
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

Write-Host "💡 Dica: abra outra janela e rode 'placar.ps1' para ver os votos em tempo real!" -ForegroundColor Yellow

# Loop de votação
while ($true) {
    Clear-Host
    Write-Host "`nDigite o número do candidato (1-$($participantes.Count)) ou 'fim' para encerrar:"
    for ($i = 0; $i -lt $participantes.Count; $i++) {
        Write-Host ("{0}. {1}" -f ($i+1), $participantes[$i].Nome)
    }

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
        # Tela de espera
        Clear-Host
        Write-Host "`n============================"
        Write-Host "=                          ="
        Write-Host "=                          ="
        Write-Host "=      Fim da Votação      ="
        Write-Host "=                          ="
        Write-Host "=                          ="
        Write-Host "============================"  
        Start-Sleep -Seconds 1  
    } else {
        Write-Host "Entrada inválida!" -ForegroundColor Red
    }
}

# Resultado final
$maxVotos = ($participantes | Measure-Object Votos -Maximum).Maximum
$vencedores = @($participantes | Where-Object { $_.Votos -eq $maxVotos })

Add-Content -Path $logPath -Value "===== Resultado Final ====="

if ($vencedores.Count -gt 1) {
    $nomesEmpate = ($vencedores | ForEach-Object { $_.Nome }) -join ', '
    Write-Host "Houve um empate entre: $nomesEmpate" -ForegroundColor Magenta
    Add-Content -Path $logPath -Value "Resultado: Empate entre $nomesEmpate"
} else {
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
    $series.Points[$i].Color = $colors[$i % $colors.Count]
}

$chart.Series.Add($series)
$form.Controls.Add($chart)

# Exporta gráfico como PNG
$chart.SaveImage($graficoPath, "Png")
Write-Host "`n📊 Gráfico salvo em: $graficoPath" -ForegroundColor Cyan

$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
