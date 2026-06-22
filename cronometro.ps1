# & $sd\cronometro.ps1 -Minutos 1 -Espera 15 -Loop
# Contador de minutos (não suporta horas), mas se usar o tempo convertido em minutos ele funciona normalmente, um bip toca no fim e com a opção de usar loop. Caso contrário ele vai fazer a contagem e parar após o bip.
param(
    [Alias('M', 'Minutos')]
    [int]$TotalMinutos = 0,

    [Alias('S', 'Segundos')]
    [int]$TotalSegundos = 0,

    [Alias('E')]
    [int]$Espera = 0,

    [Alias('L')]
    [switch]$Loop = $false,

    [Alias('R')]
    [switch]$Regressivo = $false,

    [int]$loopCount = 1,

    [string]$Mensagem,

    [bool]$TempoFinal = $true,

    [bool]$Termino = $false
)

# Definindo variaveis de Tempo Inicial e a troca de valores caso seja usado o tempo regressivo
[int]$min = 0
[int]$seg = 0
# Usando Regressivo
if ($Regressivo) {
    [int]$min = $TotalMinutos
    [int]$seg = $TotalSegundos
    [int]$copyTM = $TotalMinutos
    [int]$copyTS = $TotalSegundos
    [int]$TotalMinutos = 0
    [int]$TotalSegundos = 0
}

function myBeep {
    # Mostra a hora que terminou
    Write-Host '[' -NoNewline
    Write-Host (Get-date -Format "HH:mm:ss") -NoNewline
    Write-Host ']'

    # Beep curto (Windows)
    try {
        [console]::beep(1000,300)
    } catch {
        # Em sistemas sem beep, uma alternativa simples: tocar um som do sistema (opcional)
        Write-Host "`n(BEEP não suportado neste ambiente)`n" -ForegroundColor Red
    }
}

# Grava a hora de início
$inicio = Get-Date

# Corpo do código
while ($Termino -eq $false) {
    # Cronometro
    while ($TempoFinal -eq $true) {
        # {0:..}:{1:..} = primeiro e segundo item separados por ':'
        # {..:D2} = Decimal com duas casas, será preenchido automaticamente com zero na frente caso o valor seja menor que 10
        # Formatar os numeros para o padrão de tempo
        $tempo = "{0:D2}:{1:D2}" -f $min, $seg

        # Escreve na mesma linha, com espaço final para limpar linhas anteriores
        Write-Host ("`r Tempo: {0}`t" -f $tempo) -NoNewline
        if ($loopCount -gt 1) {
            Write-Host "Repetição: $loopCount`t" -NoNewline
        }

        # Break element
        if ($seg -eq $totalSegundos -and $min -eq $TotalMinutos) {
            myBeep
            $TempoFinal = $false
        } elseif ($Regressivo -and $min -eq 0 -and $seg -eq 0) {
            myBeep
            $TempoFinal = $false
        }

        # Incrementos
        if ($Regressivo -eq $false) {
            # Up
            $seg++
            if ($seg -eq 60) {
                $seg = 0
                $min++
            }
        } elseif ($Regressivo -eq $true) {
            # Down
            $seg--
            if ($seg -eq -1) {
                $seg = 59
                $min--
            }
        } else {
            Write-Host 'Erro na entrada de parâmetro. (minutos/segundos)'
            exit
        }

        # Segundo
        Start-Sleep -Seconds 1
    } # Fim das funções de tempo

    # Início das configurações opcionais
    # Se a opção de tempo de espera ou loop  for usada, reconfigurar o tempo
    if ($Espera -gt 0) {
        [bool]$TempoFinal = $true
    } elseif ($Loop) {
        [bool]$TempoFinal = $true
        [int]$min = 0
        [int]$seg = 0
        # Usando Regressivo
        if ($Regressivo) {
            [int]$min = $copyTM
            [int]$seg = $copyTS
        }
    } else {
        [bool]$Termino = $true
    }

    # Incrementando loop count
    $loopCount++

    # Opcional: pequena pausa antes de reiniciar
    if ($Espera -gt 0 -and $Loop) {        
        switch ($Espera) {
            {$true} { 
                for ($i = $Espera; $i -ge 0; $i--) {
                    $ProximaOnda = "{0:D2} " -f $i
                    Write-Host ("`r Próxima: {0} `tRepetição: $loopCount  " -f $ProximaOnda) -NoNewline -ForegroundColor Red
                    Start-Sleep -Seconds 1
                } 
            }
            Default { Start-Sleep -Seconds 1 }
        }
    }

    # Opcional: Mensagem extra após no fim de cada turno
    if ($Mensagem) {
        Write-Host " Mensagem: $Mensagem" -ForegroundColor Blue
    }
}

# Grava a hora do final
$fim = Get-Date

# Calcula a diferença
$duracao = $fim - $inicio

# Exibe o resultado formatado
Write-Host " Tempo total: $($duracao.ToString('hh\:mm\:ss'))" -ForegroundColor Green