Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

function Show-Graph {
    param (
        [float[]]$Latencies,
        [string]$Target = "8.8.8.8"
    )

    $form = New-Object Windows.Forms.Form
    $form.Text = "Gráfico de Latência - $Target"
    $form.Width = 800
    $form.Height = 600

    $chart = New-Object Windows.Forms.DataVisualization.Charting.Chart
    $chart.Width = 750
    $chart.Height = 500
    $chart.Top = 10
    $chart.Left = 10

    $chartArea = New-Object Windows.Forms.DataVisualization.Charting.ChartArea
    $chart.ChartAreas.Add($chartArea)

    $series = New-Object Windows.Forms.DataVisualization.Charting.Series
    $series.Name = "Latência (ms)"
    $series.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
    $series.BorderWidth = 2

    for ($i = 0; $i -lt $Latencies.Count; $i++) {
        $series.Points.AddXY($i + 1, $Latencies[$i])
    }

    $chart.Series.Add($series)
    $form.Controls.Add($chart)
    $form.ShowDialog()
}

function Test-InternetLatency {
    param (
        [string]$Target = "8.8.8.8",
        [int]$Count = 20
    )

    Write-Host "Testando latência para $Target com $Count pacotes..." -ForegroundColor Cyan
    $latencies = @()
    $lost = 0

    for ($i = 1; $i -le $Count; $i++) {
        $result = Test-Connection -ComputerName $Target -Count 1 -ErrorAction SilentlyContinue

        if ($result) {
            $latency = $result.ResponseTime
            Write-Host "Pacote $i : $latency ms" -ForegroundColor Green
            $latencies += $latency
        } else {
            Write-Host "Pacote $i : perdido" -ForegroundColor Red
            $latencies += [float]::NaN
            $lost++
        }

        Start-Sleep -Milliseconds 500
    }

    $lossPercent = [math]::Round(($lost / $Count) * 100, 2)
    Write-Host "`nResumo:"
    Write-Host "Pacotes enviados: $Count"
    Write-Host "Pacotes perdidos: $lost ($lossPercent%)" -ForegroundColor Yellow

    $validLatencies = $latencies | Where-Object { $_ -is [float] -and -not [float]::IsNaN($_) }
    if ($validLatencies.Count -gt 0) {
        $avgLatency = [math]::Round(($validLatencies | Measure-Object -Average).Average, 2)
        Write-Host "Latência média: $avgLatency ms" -ForegroundColor Cyan
    }

    Show-Graph -Latencies $latencies -Target $Target
}

# Executa o teste
Test-InternetLatency -Target "8.8.8.8" -Count 30
