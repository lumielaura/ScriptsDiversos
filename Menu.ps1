# Menu interativo PowerShell com log, Enter, Esc, funções em camelCase

# Caminho do log (Área de Trabalho do usuário)
$logPath = "$PSScriptRoot\menu_log.txt"

# Verifica se o log existe; se não, cria com cabeçalho
if (-not (Test-Path $logPath)) {
    "=== Início do log do menu ===`n" | Out-File -FilePath $logPath -Append -Encoding utf8
}

# Opções do menu
$opcoes = @(
    "Opção 1: Mostrar frase 1",
    "Opção 2: Mostrar frase 2",
    "Opção 3: Mostrar frase 3",
    "Opção 4: Mostrar frase 4",
    "Opção 5: Mostrar frase 5",
    "Sair sem selecionar"
)

function escreverLog {
    param ($mensagem)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $mensagem" | Out-File -FilePath $logPath -Append -Encoding utf8
}

function mostrarFrase {
    param ($index)
    Clear-Host
    switch ($index) {
        0 { $mensagem = "Opção 1: 'Hoje é um bom dia para aprender PowerShell.'" }
        1 { $mensagem = "Opção 2: 'Automatizar tarefas é uma forma de ganhar tempo.'" }
        2 { $mensagem = "Opção 3: 'Scripts bem feitos evitam erros repetitivos.'" }
        3 { $mensagem = "Opção 4: 'O conhecimento é a chave para a liberdade.'" }
        4 { $mensagem = "Opção 5: 'Dominar o terminal é um superpoder do século 21.'" }
        5 { 
            escreverLog "Usuário escolheu: Sair sem selecionar"
            return $false 
        }
    }

    Write-Host "Você escolheu: $mensagem"
    escreverLog "Usuário escolheu: $mensagem"

    Write-Host "`nPressione qualquer tecla para voltar ao menu..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    return $true
}

function desenharMenu {
    param ($index, $opcoes)
    Clear-Host
    Write-Host "Use as setas ↑ ↓ para navegar. ENTER para selecionar. ESC para sair.`n"
    for ($i = 0; $i -lt $opcoes.Length; $i++) {
        if ($i -eq $index) {
            Write-Host "> $($opcoes[$i])" -ForegroundColor Cyan
        } else {
            Write-Host "  $($opcoes[$i])"
        }
    }
}

do {
    $index = 0
    $maxIndex = $opcoes.Length - 1
    $sairComEsc = $false

    do {
        desenharMenu $index $opcoes
        # Este comando espera pela entrada do usuario, essa entrada sera gravada na variavel key
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

        switch ($key.VirtualKeyCode) {
            38 { if ($index -gt 0) { $index-- } }   # Seta ↑
            40 { if ($index -lt $maxIndex) { $index++ } } # Seta ↓
            27 { $sairComEsc = $true; break } # Esc
        }

        if ($key.VirtualKeyCode -eq 13 -or $key.Character -eq "`r") {
            break
        }

    } while ($true)

    if ($sairComEsc) {
        escreverLog "Usuário saiu com tecla ESC"
        break
    }

    $continuar = mostrarFrase $index

} while ($continuar)

Clear-Host
Write-Host "Saindo do menu. Até a próxima!"
