# Pergunta ao usuário o limite de entradas
$limite = Read-Host "Digite o número de entradas que deseja registrar"
[int]$limite

# Lista para armazenar os tempos
$tempos = @()

# Inicia o cronômetro
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

Write-Host "Pressione ENTER para registrar o tempo. Última entrada será usada para finalizar."

for ($i = 0; $i -lt $limite; $i++) {
    Read-Host
    $tempos += $stopwatch.Elapsed
    Write-Host ("Registro $($i+1): {0:hh\:mm\:ss\,fff}" -f $stopwatch.Elapsed)
}

# Criando as linhas no formato desejado
$linhas = @()
for ($i = 0; $i -lt $tempos.Count; $i++) {
    if ($i -eq 0) {
        # Primeiro valor sempre 00:00:00,050
        $inicio = [TimeSpan]::FromMilliseconds(50)
    } else {
        $inicio = $tempos[$i]
    }

    if ($i -lt $tempos.Count - 1) {
        # Segundo valor = próximo registro - 200ms
        $fim = $tempos[$i + 1].Subtract([TimeSpan]::FromMilliseconds(200))
        if ($fim -lt [TimeSpan]::Zero) {
            $fim = [TimeSpan]::Zero
        }
    } else {
        # Último valor = mesmo do último enter
        $fim = $tempos[$i]
    }

    # Formata para o padrão 00:00:00,050
    $inicioStr = "{0:00}:{1:00}:{2:00},{3:000}" -f $inicio.Hours, $inicio.Minutes, $inicio.Seconds, $inicio.Milliseconds
    $fimStr = "{0:00}:{1:00}:{2:00},{3:000}" -f $fim.Hours, $fim.Minutes, $fim.Seconds, $fim.Milliseconds

    $linha = "$inicioStr --> $fimStr"
    $linhas += $linha
    Write-Host $linha   # Mostra na tela também
}

# Caminho do arquivo de log (salva no diretório atual)
# $arquivo = Join-Path $PWD "SRTtempo.txt"
$arquivo = Join-Path $PSScriptRoot "SRTtempo.txt"
$linhas | Set-Content -Path $arquivo -Encoding UTF8

Write-Host "`nRegistros salvos em: $arquivo"
