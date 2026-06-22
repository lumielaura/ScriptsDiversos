<#
.SYNOPSIS
    Ver hora no terminal com alarme opcional.
.DESCRIPTION
    Script simples para ver o horário no terminal, com alarme opcional e um pequeno sincronizador antes de começar. 
.NOTES
    A hora não esta perfeitamente sincronizada, mas esta funcional para ver o horário no terminal.
    O alarme funciona apenas colocando o horário no formato separado por ':'.
    O sincronizador foi usado apenas por estética, a ideia veio de jogos de gundam que joguei recentemente. 
.EXAMPLE
    ./verHora.ps1
    & $sd\verHora.ps1
    & $sd\verHora.ps1 -Alarme 11:30
#>

param (
    $Alarme
)

function myBeep {
    # Mostra a hora que terminou
    Write-Host " [Alarme!!!] " -ForegroundColor Red

    # Beep curto (Windows)
    try {
        [console]::beep(1000,500)
        Start-Sleep -Milliseconds 600
        [console]::beep(1000,500)
        Start-Sleep -Milliseconds 600
        [console]::beep(1000,500)
        Start-Sleep -Milliseconds 600
        [console]::beep(1000,500)
        Start-Sleep -Milliseconds 600
        [console]::beep(1000,500)
    } catch {
        # Em sistemas sem beep, uma alternativa simples: tocar um som do sistema (opcional)
        Write-Host "`n(BEEP não suportado neste ambiente)`n" -ForegroundColor Red
    }
}

try {    
    # calcular segundos restantes
    $segundos = 60-[int](get-date -Format "ss")
    $ponto = 1
    
    # sincronizar hora
    for($i = $segundos; $i -gt 0; $i--)
    {
        Write-Host "`r Sincronizando: $i " -NoNewline -ForegroundColor Blue
        Write-Host ('.' * $ponto + '  ') -NoNewline -ForegroundColor Blue
        if ($ponto -eq 3) {
            $ponto = 0
        }    
        $ponto++
        Start-Sleep -Seconds 1
    }
}
finally {
    Write-Host "`r Sincronizando: OK   " -ForegroundColor Blue 
    
    # Alarme
    if ($Alarme) {
        $alaVar = $Alarme -split ':'
        Write-Host " Alarme Programado: $($Alarme)" -ForegroundColor Blue
    }
}

# hora
while ($true) {
    $tempo = get-date -Format "HH:mm"
    Write-Host "`r Horário: " -NoNewline -ForegroundColor Blue
    Write-Host "   $tempo   " -NoNewline -ForegroundColor Black -BackgroundColor White
    
    # Alarme
    if ($Alarme) {
        $tempoVar = $tempo -split ':'
        if ($tempoVar[0] -ge $alaVar[0] -and $tempoVar[1] -ge $alaVar[1]) {
            myBeep
            Break
        }
    }
    
    # Tempo de atualização
    Start-Sleep -Seconds 10
}