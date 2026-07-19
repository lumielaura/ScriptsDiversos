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
    & $sd\verHora.ps1 -Alarme 11:35 -Sincronizar $false
    & $sd\verHora.ps1 -A 12:30 -S $false
#>

param (
    [Alias('A')]
    $Alarme,

    [Alias('S')]
    [bool]$Sincronizar = $true
)

function myBeep {
    # Mostra a hora que terminou
    Write-Host " [Alarme!!!] " -ForegroundColor Red

    # Beep curto (Windows)
    try {
        for ($i = 0; $i -lt 5; $i++) {
            [console]::beep(1000,500)
            Start-Sleep -Milliseconds 600
        }
    } catch {
        # Em sistemas sem beep, uma alternativa simples: tocar um som do sistema (opcional)
        Write-Host "`n(BEEP não suportado neste ambiente)`n" -ForegroundColor Red
    }
}

try {    
    # calcular segundos restantes
    $segundos = 60-[int](get-date -Format "ss")
    $ponto = 1

    # Alarme
    if ($Alarme -match "^([01]\d|2[0-3]):[0-5]\d$") {
        $alaVar = $Alarme -split ':'
        Write-Host " Alarme Programado: " -ForegroundColor Blue -NoNewline
        Write-Host $Alarme -ForegroundColor DarkYellow
    } elseif ($Alarme -like "*" -and $null -ne $Alarme) {
        Write-Host " Erro: O Alarme esta no formato errado`n Digite-o da seguinte forma: " -ForegroundColor Red -NoNewline
        Write-Host "$(Get-date -Format "HH:mm")" -ForegroundColor White
        exit
    }
}
finally {      
    # sincronizar hora
    if ($Sincronizar) { # is true
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
        Write-Host "`r Sincronizando: " -ForegroundColor Blue -NoNewline
        Write-Host "OK   " -ForegroundColor DarkYellow
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
        if ($tempoVar[0] -eq $alaVar[0] -and $tempoVar[1] -ge $alaVar[1]) {
            myBeep
            Break
        }
    }
    
    # Tempo de atualização
    Start-Sleep -Seconds 10
}