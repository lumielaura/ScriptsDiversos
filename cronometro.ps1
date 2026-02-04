# & $sd\cronometro.ps1 -Minutos 1 -Espera 15 -Loop
# Contador de minutos (não suporta horas), mas se usar o tempo convertido em minutos ele funciona normalmente, um bip toca no fim e com a opção de usar loop. Caso contrário ele vai fazer a contagem e parar após o bip.
param(
    [Alias('M', 'Minutos')]
    [int]$TotalMinutos = 0,

    [Alias('S', 'Segundos')]
    [int]$TotalSegundos = 0,
    
    [Alias('E')]
    [int]$Espera = 0,
    
    [switch]$Loop,
    [int]$loopCount = 1,
    
    # Definindo Tempo Inicial
    [int]$min = 0,
    [int]$seg = 0,
    
    [bool]$TempoFinal = $true
)

function myBeep {
    # Beep curto (Windows)
    try {
        [console]::beep(1000,300)
    } catch {
        # Em sistemas sem beep, uma alternativa simples: tocar um som do sistema (opcional)
        Write-Host "`n(BEEP não suportado neste ambiente)`n" -ForegroundColor Red
    }
}

# Corpo do código
do {
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
            Write-Host "Tempo Alcançado Segundos"
            myBeep
            $TempoFinal = $false
        }

        # Incrementos
        $seg++
        if ($seg -eq 60) {
            $seg = 0
            $min++
        }

        Start-Sleep -Seconds 1
    }

    # Se a opção de tempo de espera for usada, o loop vai ser habilitado
    if ($Espera -gt 0) {
        [switch]$loop = $true
    } else {
        [switch]$loop = $false
    }

    # Opcional: pequena pausa antes de reiniciar
    if ($Espera -gt 0 -and $Loop) {        
        switch ($Espera) {
            {$true} { 
                $loopCount++
                for ($i = $Espera; $i -ge 0; $i--) {
                    $ProximaOnda = "{0:D2} " -f $i
                    Write-Host ("`r Próxima: {0} `tRepetição: $loopCount  " -f $ProximaOnda) -NoNewline -ForegroundColor Red
                    Start-Sleep -Seconds 1
                } 
            }
            Default { Start-Sleep -Seconds 1 }
        }
    }

} while (
    $Loop
)