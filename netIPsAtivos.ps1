param (
    [int]
    $IP = 0
)
# Buscar ip pessoal
try {
    $meuIP = Get-NetIPConfiguration -Detailed | Select-Object -ExpandProperty IPv4Address    
}
catch {
    Write-Host "Aconteceu um erro: $($_)"
    break
}

# recortar apenas endereço de rede 
$redeIP = $meuIP -replace '\.\d+$', ''

# "Valor atual(IP): $IP"
$listaIP = [System.Collections.Generic.List[string]]::new()
if ($IP -eq 0) {
    # Procurar em toda rede
    1..254 | ForEach-Object {
        if (Test-Connection ($redeIP + "." + $_) -Quiet -Count 1 -TimeoutSeconds 1) {
            Write-Host "`r$_ está Online  " -ForegroundColor Green -NoNewline
            ""
            $listaIP.Add($_)
        } else {
            Write-Host "`r$_ está Offline " -ForegroundColor Red -NoNewline
        }
    }
} else {
    # Usar ip específico
    if (Test-Connection 192.168.1.$IP -Quiet -Count 1) {
        Write-Host "$($IP) está Online" -ForegroundColor Green
    } else {
        Write-Host "$($IP) está Offline" -ForegroundColor Red
    }
}

$listaIP | ForEach-Object {
    try { 
        $IPatual = Test-Connection 192.168.1.$_ -Count 1 -TimeoutSeconds 1 | Select-Object -ExpandProperty Address
        Test-Connection 192.168.1.$_ -Count 1 -TimeoutSeconds 1 -ResolveDestination 
    }
    catch {
        Write-Host "`rErro em $($IPatual): $_"
    }
}