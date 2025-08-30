# Arquivos de entrada
$arquivoTempos = Join-Path $PSScriptRoot "SRTtempo.txt"
$arquivoLetras = Join-Path $PSScriptRoot "SRTletras.txt"
$arquivoSRT = Join-Path $PSScriptRoot "SRTresultado.srt"

# Lê os arquivos
$tempos = Get-Content $arquivoTempos
$letras = Get-Content $arquivoLetras

# Verifica se os arquivos têm o mesmo número de linhas
if ($tempos.Count -ne $letras.Count) {
    Write-Host "⚠ Atenção: número de linhas de tempo e texto não é igual!"
    Write-Host "Tempos: $($tempos.Count), Letras: $($letras.Count)"
}

# Junta os arquivos no formato SRT
$saida = @()
for ($i = 0; $i -lt [Math]::Min($tempos.Count, $letras.Count); $i++) {
    $saida += ($i + 1)              # índice
    $saida += $tempos[$i]           # tempo
    $saida += $letras[$i]           # texto
    $saida += ""                    # linha em branco
}

# Salva o resultado
$saida | Set-Content -Path $arquivoSRT -Encoding UTF8

Write-Host "Arquivo SRT gerado: $arquivoSRT"
