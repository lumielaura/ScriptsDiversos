<#
.SYNOPSIS
    Faz um teste da conexão de internet.
.DESCRIPTION
    Faz um teste simples com ip definido no inicio do arquivo, mostra um gráfico com o valor de ping, estado da internet (com arquivo de log) e estabilidade da rede.
.NOTES
    Sem notas adicionais.
.EXAMPLE
    ./internetStatus.ps1
#>

# Ip usado para testar a conexao
$site = "8.8.8.8"

# Nome resolvido para mostrar na tela
$siteResolvido = Test-Connection $site -Count 1 -ResolveDestination -ErrorAction SilentlyContinue

# Intervalo entre testes (em segundos)
$intervalo = 10

# Estado anterior da conexão (ainda será detectado no início)
$estadoConexao = $null

# Grafico internet (Arquivo Log)
$pathGraph = Join-Path $PSScriptRoot "internetGraph.txt"
if (-not (Test-Path $pathGraph)) {
    "=== Inicio do arquivo de Ping ===" | Out-File -FilePath $pathGraph -Append -Encoding utf8
    Add-Content -Path $pathGraph  -Value ("`n" * 19)
} else {
    "=== Inicio do arquivo de Ping ==="| Out-File -FilePath $pathGraph -Encoding utf8
    Add-Content -Path $pathGraph  -Value ("`n" * 19)
}

# Grafico internet (Função)
function internetGraph {
    # Quantidade de valores a exibir
    $qtd = 20

    # Lê os últimos números do arquivo
    $dados = Get-Content $pathGraph |
            Where-Object { $_ -match '^\d+$' -or $_ -eq "" } |
            Select-Object -Last $qtd |
            ForEach-Object { [int]$_ }

    # Valor máximo (para escala)
    $max = ($dados | Measure-Object -Maximum).Maximum

    # Largura máxima da barra no terminal
    $larguraBarra = 40

    # Contador
    $indice = 1

    foreach ($valor in $dados) {

        # Calcula o tamanho proporcional da barra
        $tamanho = if ($max -gt 0) {
            [math]::Round(($valor / $max) * $larguraBarra)
        } else {
            0
        }
        
        switch ($valor) {
            {$_ -ge 1 -and $_ -lt 60} { $color = 'Green' }
            {$_ -ge 60 -and $_ -lt 100} { $color = 'Yellow' }
            Default { $color = 'Red' }
        }

        # Desenha o gráfico
        Write-Host ("{0,2} | " -f $indice) -NoNewline -ForegroundColor $color
        Write-Host ("." * $tamanho) -NoNewline -ForegroundColor $color
        Write-Host " ($valor)" -ForegroundColor $color

        $indice++
    }
}

# Caminho do log
$logPath = Join-Path $PSScriptRoot "internetStatusLog.txt"
# Função para registrar no log
function registrarLog {
    param (
        [string]$mensagem
    )
    $hora = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
    "$hora - $mensagem" | Out-File -FilePath $logPath -Append -Encoding utf8
}

# criando barra colorida
$cBar = '='
$nBar = 48
function barraStatus {
    Write-Host ($cBar*$nBar) -ForegroundColor Yellow
}

# Verificando status da conexao
function internetStatus {
    switch ($conexao.Status) {
        {$_ -eq 'Success'} { 
            Write-Host " Estado da Conexão`t" -NoNewline -ForegroundColor Cyan
            Write-Host "✅"
            break 
        }
        Default {
            Write-Host " Estado da Conexão`t" -NoNewline -ForegroundColor Cyan
            Write-Host "❌"
        }
    }    
}

# Verificando latencia
function internetLatency {
    # variavel latencia
    $latencia = $conexao.Latency
    switch ($latencia) {
        {$_ -ge 1 -and $_ -lt 10} {  # Easter Egg - ADM           
            Write-Host " Estabilidade da Rede`t" -NoNewline -ForegroundColor Cyan
            Write-Host "Deus da Rede ✨" -ForegroundColor Green
            Write-Host " Velocidade da Rede`t" -ForegroundColor Cyan -NoNewline
            Write-Host $latencia -ForegroundColor Green
            break 
        }
        {$_ -ge 10 -and $_ -lt 60} {             
            Write-Host " Estabilidade da Rede`t" -NoNewline -ForegroundColor Cyan
            Write-Host "Internet Normal ✨" -ForegroundColor Green
            Write-Host " Velocidade da Rede`t" -ForegroundColor Cyan -NoNewline
            Write-Host $latencia -ForegroundColor Green
            break 
        }
        {$_ -ge 60 -and $_ -lt 100} { 
            Write-Host " Estabilidade da Rede`t" -NoNewline -ForegroundColor Cyan
            Write-Host "Internet Lenta 🍂" -ForegroundColor Yellow
            Write-Host " Velocidade da Rede`t" -ForegroundColor Cyan -NoNewline
            Write-Host $latencia -ForegroundColor Yellow
            break 
        }
        {$_ -ge 100 -and $_ -lt 200} { 
            Write-Host " Estabilidade da Rede`t" -NoNewline -ForegroundColor Cyan
            Write-Host "Internet Muito Lenta ❌" -ForegroundColor Red
            Write-Host " Velocidade da Rede`t" -ForegroundColor Cyan -NoNewline
            Write-Host $latencia -ForegroundColor Red
            break 
        }
        Default {
            Write-Host " Erro:`tInternet com problema | Conexão Perdida ❌" -ForegroundColor Red
        }
    }    
}

function statusWindown {
    Clear-Host
    barraStatus
    Write-Host " Monitorando conexão com a internet..." -ForegroundColor Cyan
    Write-Host " Testando conectividade com " -ForegroundColor Cyan -NoNewline
    if ($null -eq $siteResolvido) {
        Write-Host "Erro na busca ao nome de IP" -ForegroundColor Red
    } else {
        Write-Host "$($siteResolvido.Destination)" -ForegroundColor Yellow        
    }
    Write-Host " Log: $($logPath)" -ForegroundColor DarkGray
    Write-Host " (Pressione Ctrl + C para sair)" -ForegroundColor DarkGray
    barraStatus
}

# Corpo do Código - Aqui começa a mágica (Sem interação com o usuário)
while ($true) {
    # Coletando dados da conexão
    $conexao = Test-Connection -ComputerName $site -Count 1 -ErrorAction SilentlyContinue    

    # Adicionando valor ping ao arquivo de log
    if ($null -eq $conexao) {
        Add-Content -Path $pathGraph -Value ""
    } else {
        Add-Content -Path $pathGraph -Value $conexao.Latency
    }

    # Informações mostradas na tela do usuario
    statusWindown    
    internetStatus
    internetLatency
    barraStatus
    internetGraph
    barraStatus

    # [Adicional] Toca um bit caso o estado da internet mude e faz um registro no arquivo de log.
    if ($conexao -and ($estadoConexao -ne $true)) {
        # Escrever log
        $mensagem = "✅ Internet Normal. ✨"
        registrarLog $mensagem
        # Com conexão com o IP
        try {
            # Bip Sound
            [console]::Beep(300,200)
            Start-Sleep -Milliseconds 50
            [console]::Beep(400,200)
        }
        catch {
            Write-Host " O sistema não suporta o Sons de Bip" -ForegroundColor Red
        }
        $estadoConexao = $true
    }
    elseif (-not $conexao -and ($estadoConexao -ne $false)) {
        # Escrever log
        $mensagem = "❌ A Conexão com a Internet foi Perdida! 🍂"
        registrarLog $mensagem
        # Sem conexão com o IP
        try {
            # Bip Sound
            [console]::Beep(300,200)
            Start-Sleep -Milliseconds 50
            [console]::Beep(300,200)
        }
        catch {
            Write-Host " O sistema não suporta o Sons de Bip" -ForegroundColor Red
        }
        $estadoConexao = $false
    }

    # Pequena pausa ate o próximo comando
    Start-Sleep -Seconds $intervalo
}