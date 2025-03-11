# Script para testar a conexão de internet e faz um pequeno log do horario que ela voltou ao normal ou foi cortada

[bool]$swiKay = $true;
$emp;

do {    
    $comando = Test-Connection -Count 1 -Ping -IPv4 8.8.8.8 -Quiet
    Start-Sleep -Seconds 10;
    
    switch ($comando) {
        
        'True' { 
            # "Conexao de internet normal"   
            if ($swiKay -eq $true) {
                $data = get-date -Format 'dd/MM/yyyy HH:mm';
                Write-Output "A conexao com a internet foi estabelecida as $data." >> "$PSScriptRoot\logConnect.txt"
                $swiKay = $false;
            }
        }
        'False' { 
            # "Sem conexao de internet"        
            if ($swiKay -eq $false) {
                $data = get-date -Format 'dd/MM/yyyy HH:mm';
                Write-Output "A conexao foi perdida as $data.`n" >> "$PSScriptRoot\logConnect.txt"
                $swiKay = $true;
            }
        }
    } Clear-Variable comando
} until (
    $emp -eq 2
)