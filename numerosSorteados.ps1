# Caminho do arquivo que armazena os números sorteados
$savePath = "$PSScriptRoot\numeros_sorteados.json"

# Se existir, carregar os números sorteados
if (Test-Path $savePath) {
    $script:sorteados = (Get-Content $savePath -Raw | ConvertFrom-Json)
    if ($null -eq $script:sorteados) { $script:sorteados = @() }
    elseif ($script:sorteados -isnot [System.Array]) { $script:sorteados = @([int]$script:sorteados) }
    else { $script:sorteados = $script:sorteados | ForEach-Object { [int]$_ } }
} else {
    $script:sorteados = @()
}

function salvar {
    $script:sorteados | ConvertTo-Json -Compress | Out-File -FilePath $savePath -Encoding UTF8
}

function mostrarNumeros {
    Clear-Host
    Write-Host "=== Números sorteados ===" -ForegroundColor Cyan

    if ($script:sorteados.Count -eq 0) {
        Write-Host "Nenhum número sorteado ainda." -ForegroundColor DarkGray
        return
    }

    # Mostrar em formato de tabela 10x10
    for ($i = 1; $i -le 100; $i++) {
        if ($script:sorteados -contains $i) {
            if ($i -eq $script:sorteados[-1]) {
                Write-Host ("{0,3}" -f $i) -NoNewline -ForegroundColor Yellow -BackgroundColor DarkBlue
            } else {
                Write-Host ("{0,3}" -f $i) -NoNewline -ForegroundColor Green
            }
        } else {
            Write-Host ("{0,3}" -f $i) -NoNewline -ForegroundColor DarkGray
        }

        if ($i % 10 -eq 0) { Write-Host "" }
    }

    Write-Host "`nÚltimo número: " -NoNewline
    Write-Host $script:sorteados[-1] -ForegroundColor Green
}

function sortearNumero {
    if ($script:sorteados.Count -ge 100) {
        Write-Host "Todos os números já foram sorteados!" -ForegroundColor Red
        return
    }
    do {
        $novo = Get-Random -Minimum 1 -Maximum 101
    } until (-not ($script:sorteados -contains $novo))

    $script:sorteados = @($script:sorteados + $novo | ForEach-Object { [int]$_ })
    salvar
    mostrarNumeros
}

function resetar {
    $script:sorteados = @()
    if (Test-Path $savePath) { Remove-Item $savePath }
    mostrarNumeros
}

# Loop do menu
while ($true) {
    mostrarNumeros
    Write-Host "`nOpções:"
    Write-Host "1 - Sortear número"
    Write-Host "2 - Resetar lista"
    Write-Host "0 - Sair"
    $opcao = Read-Host "Escolha uma opção"

    switch ($opcao) {
        "1" { sortearNumero }
        "2" { resetar }
        "0" { return }   # <-- agora realmente sai do programa
        default { Write-Host "Opção inválida" -ForegroundColor Red; Start-Sleep 1 }
    }
}
