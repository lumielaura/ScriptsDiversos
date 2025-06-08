# Como executar
# powershell -ExecutionPolicy Bypass -File .\monitorInternet.ps1

# Caminho do log
$logPath = "$PSScriptRoot\log_internet.txt"

# Intervalo entre testes (em segundos)
$intervalo = 10

# site para testar
$site = "8.8.8.8"

# Estado anterior da conexão (ainda será detectado no início)
$conectadoAnteriormente = $null

# Função para registrar no log
function registrarLog {
    param (
        [string]$mensagem
    )
    $hora = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$hora - $mensagem" | Out-File -FilePath $logPath -Append -Encoding utf8
}

Write-Host "========================================" -ForegroundColor Yellow
Write-Host " Monitorando conexão com a internet...  " -ForegroundColor Cyan
Write-Host " Testando conectividade com $site" -ForegroundColor Cyan
Write-Host " Log: $logPath" -ForegroundColor DarkGray
Write-Host " (Pressione Ctrl + C para sair)" -ForegroundColor DarkGray
Write-Host "========================================" -ForegroundColor Yellow

while ($true) {
    $ping = Test-Connection -ComputerName $site -Count 1 -Quiet

    if ($ping -and ($conectadoAnteriormente -ne $true)) {
        $mensagem = "✅ Internet Normal. ✨"
        Write-Host $mensagem -ForegroundColor Green
        registrarLog $mensagem
        $conectadoAnteriormente = $true
    }
    elseif (-not $ping -and ($conectadoAnteriormente -ne $false)) {
        $mensagem = "❌ A Conexão com a Internet foi Perdida! 🍂"
        Write-Host $mensagem -ForegroundColor Red
        registrarLog $mensagem
        $conectadoAnteriormente = $false
    }

    Start-Sleep -Seconds $intervalo
}
