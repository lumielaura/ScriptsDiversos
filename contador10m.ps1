# Contador de 0 a 10 minutos, toca no fim e reinicia (loop infinito)
# Usa Stopwatch para medir tempo decorrido (mais confiável que Get-Date para contagem)

$totalMinutes = 10

while ($true) {
    for ($min = 0; $min -lt $totalMinutes; $min++) {
        for ($sec = 0; $sec -lt 60; $sec++) {
            # Formatar os numeros para o padrão de tempo
            $tempo = "{0:D2}:{1:D2}" -f $min, $sec
            
            # Escreve na mesma linha, com espaço final para limpar linhas anteriores
            Write-Host ("`rTempo: {0}  " -f $tempo) -NoNewline
            
            Start-Sleep -Seconds 1
        }
    }
    
    # Mostrar o tempo final
    $sec = 0
    $tempo = "{0:D2}:{1:D2}" -f $totalMinutes, $sec
    Write-Host ("`rTempo: {0}  " -f $tempo) -NoNewline

    # Beep curto (Windows)
    try {
        [console]::beep(1000,300)
    } catch {
        # Em sistemas sem beep, uma alternativa simples: tocar um som do sistema (opcional)
        Write-Host "`n(BEEP não suportado neste ambiente)`n"
    }

    # Opcional: pequena pausa antes de reiniciar
    Start-Sleep -Seconds 1
}
