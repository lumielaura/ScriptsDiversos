# Como executar
# powershell -ExecutionPolicy Bypass -File .\monitorInternet.ps1

# Caminho do log
$logPath = "$PSScriptRoot\log_internet.txt"

# Intervalo entre testes (em segundos)
$intervalo = 10

# site para testar
$site = "8.8.8.8"

# Estado anterior da conexão
$conectadoAnteriormente = $true

# Função para registrar no log
function registrarLog {
    param (
        [string]$mensagem
    )
    $hora = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$hora - $mensagem" | Out-File -FilePath $logPath -Append -Encoding utf8
}

Write-host "Monitorando conexão com a internet... (Ctrl + C para sair)"
Write-host "Log: $logPath"

while ($true) {
    $ping = Test-Connection -ComputerName $site -Count 1 -Quiet

    if ($ping -and -not $conectadoAnteriormente) {
        $mensagem = "✅ Internet Normal. ✨"
        Write-host $mensagem -ForegroundColor Green
        registrarLog $mensagem
        $conectadoAnteriormente = $true
    }
    elseif (-not $ping -and $conectadoAnteriormente) {
        $mensagem = "❌ A Conexão com a Internet foi Perdida! 🍂"
        Write-host $mensagem -ForegroundColor Red
        registrarLog $mensagem
        $conectadoAnteriormente = $false
    }

    Start-Sleep -Seconds $intervalo
}
