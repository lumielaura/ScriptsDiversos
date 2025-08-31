# Caminho dos arquivos
$arquivoProdutos = "$PSScriptRoot\controleProdutos-EXP.json"
$arquivoCSV = "$PSScriptRoot\controleProdutos-EXP.csv"

# Valor padrão do limite de estoque baixo
$limiteEstoqueBaixo = 5
# Prazo padrão de alerta de validade (em dias)
$prazoValidade = 7

# Carrega dados do JSON se existir
if (Test-Path $arquivoProdutos) {
    $json = Get-Content $arquivoProdutos -Raw | ConvertFrom-Json
    $produtos = @{}
    foreach ($item in $json.Produtos.PSObject.Properties) {
        $produtos[$item.Name] = @{
            Quantidade      = [int]$item.Value.Quantidade
            DataRegistro    = $item.Value.DataRegistro
            UltimaAlteracao = $item.Value.UltimaAlteracao
            Validade        = $item.Value.Validade
        }
    }
    if ($json.LimiteEstoqueBaixo) {
        $limiteEstoqueBaixo = [int]$json.LimiteEstoqueBaixo
    }
} else {
    $produtos = @{}
}

function mostrarMenu {
    Clear-Host
    Write-Host "=== Controle de Produtos ===`n"
    Write-Host "1 - Adicionar produto"
    Write-Host "2 - Alterar quantidade"
    Write-Host "3 - Remover produto"
    Write-Host "4 - Listar produtos"
    Write-Host "5 - Exportar para CSV"
    Write-Host "6 - Pesquisar produto"
    Write-Host "7 - Configurar limite de estoque baixo (atual: $limiteEstoqueBaixo)"
    Write-Host "8 - Salvar e sair"
    Write-Host "9 - Alterar validade de produto"
    Write-Host "10 - Listar produtos próximos da validade"
    Write-Host ""
}

function mostrarProduto($nome, $dados) {
    $status = if ($dados.Quantidade -lt $limiteEstoqueBaixo) { " (ESTOQUE BAIXO!)" } else { "" }
    $linha = "[$nome] $($dados.Quantidade)$status - Registrado em: $($dados.DataRegistro) - Última alteração: $($dados.UltimaAlteracao)"
    if ($dados.Validade) {
        $linha += " - Validade: $($dados.Validade)"
    }
    if ($dados.Quantidade -lt $limiteEstoqueBaixo) {
        Write-Host $linha -ForegroundColor Red
    } else {
        Write-Host $linha
    }
}

function verificarValidadeAutomatica {
    $hoje = Get-Date
    $limite = $hoje.AddDays($prazoValidade)
    $produtosComValidade = $produtos.GetEnumerator() | Where-Object { $_.Value.Validade }

    $alertas = @()

    foreach ($item in $produtosComValidade) {
        try {
            $dataValidade = [datetime]::ParseExact($item.Value.Validade, "dd/MM/yyyy", $null)
            if ($dataValidade -lt $hoje) {
                $alertas += @{ Produto = $item.Key; Status = "Vencido"; Data = $item.Value.Validade }
            } elseif ($dataValidade -le $limite) {
                $alertas += @{ Produto = $item.Key; Status = "Próximo"; Data = $item.Value.Validade }
            }
        } catch {
            $alertas += @{ Produto = $item.Key; Status = "Inválido"; Data = $item.Value.Validade }
        }
    }

    if ($alertas.Count -gt 0) {
        Write-Host "`n=== ALERTAS DE VALIDADE (prazo $prazoValidade dias) ==="
        foreach ($a in $alertas) {
            switch ($a.Status) {
                "Vencido"  { Write-Host "❌ [$($a.Produto)] - Vencido em $($a.Data)" -ForegroundColor Red }
                "Próximo"  { Write-Host "⚠️ [$($a.Produto)] - Vence em $($a.Data)" -ForegroundColor Yellow }
                "Inválido" { Write-Host "[$($a.Produto)] - Validade inválida: $($a.Data)" -ForegroundColor Magenta }
            }
        }
    }
}

do {
    mostrarMenu
    $opcao = Read-Host "Escolha uma opção"

    switch ($opcao) {
        "1" {
            $nome = Read-Host "Digite o nome do produto"
            if ($produtos.ContainsKey($nome)) {
                Write-Host "Produto já existe. Use a opção 2 para alterar." -ForegroundColor Yellow
            } else {
                $quantidade = Read-Host "Digite a quantidade"
                $validade = Read-Host "Digite a validade (ou deixe em branco) - Formato: dd/MM/yyyy"
                $agora = (Get-Date -Format "dd/MM/yyyy HH:mm")
                $produtos[$nome] = @{
                    Quantidade      = [int]$quantidade
                    DataRegistro    = $agora
                    UltimaAlteracao = $agora
                    Validade        = if ($validade) { $validade } else { $null }
                }
                Write-Host "Produto adicionado com sucesso!" -ForegroundColor Green
            }
            Pause
        }
        "2" {
            $nome = Read-Host "Digite o nome do produto que deseja alterar"
            if ($produtos.ContainsKey($nome)) {
                $novaQtd = Read-Host "Digite a nova quantidade"
                $produtos[$nome].Quantidade = [int]$novaQtd
                $produtos[$nome].UltimaAlteracao = (Get-Date -Format "dd/MM/yyyy HH:mm")
                Write-Host "Quantidade alterada com sucesso!" -ForegroundColor Green
            } else {
                Write-Host "Produto não encontrado." -ForegroundColor Red
            }
            Pause
        }
        "3" {
            $nome = Read-Host "Digite o nome do produto que deseja remover"
            if ($produtos.ContainsKey($nome)) {
                $produtos.Remove($nome)
                Write-Host "Produto removido com sucesso!" -ForegroundColor Green
            } else {
                Write-Host "Produto não encontrado." -ForegroundColor Red
            }
            Pause
        }
        "4" {
            if ($produtos.Count -eq 0) {
                Write-Host "Nenhum produto cadastrado." -ForegroundColor Yellow
            } else {
                Write-Host "`n=== Lista de Produtos ==="
                foreach ($item in $produtos.GetEnumerator()) {
                    mostrarProduto $item.Key $item.Value
                }
                verificarValidadeAutomatica
            }
            Pause
        }
        "5" {
            if ($produtos.Count -eq 0) {
                Write-Host "Nenhum produto cadastrado para exportar." -ForegroundColor Yellow
            } else {
                $listaExport = foreach ($item in $produtos.GetEnumerator()) {
                    $status = if ($item.Value.Quantidade -lt $limiteEstoqueBaixo) { "Estoque Baixo" } else { "OK" }
                    [PSCustomObject]@{
                        Produto        = $item.Key
                        Quantidade     = $item.Value.Quantidade
                        Status         = $status
                        DataRegistro   = $item.Value.DataRegistro
                        UltimaAlteracao= $item.Value.UltimaAlteracao
                        Validade       = $item.Value.Validade
                    }
                }
                $listaExport | Export-Csv -Path $arquivoCSV -NoTypeInformation -Encoding UTF8
                Write-Host "Dados exportados para $arquivoCSV" -ForegroundColor Cyan
            }
            Pause
        }
        "6" {
            $busca = Read-Host "Digite o nome (ou parte do nome) do produto"
            $resultados = $produtos.GetEnumerator() | Where-Object { $_.Key -like "*$busca*" }
            if ($resultados) {
                Write-Host "`n=== Resultados da pesquisa ==="
                foreach ($item in $resultados) {
                    mostrarProduto $item.Key $item.Value
                }
            } else {
                Write-Host "Nenhum produto encontrado." -ForegroundColor Yellow
            }
            Pause
        }
        "7" {
            $novoLimite = Read-Host "Digite o novo limite de estoque baixo"
            if ($novoLimite -match '^\d+$') {
                $limiteEstoqueBaixo = [int]$novoLimite
                Write-Host "Novo limite configurado: $limiteEstoqueBaixo" -ForegroundColor Green
            } else {
                Write-Host "Valor inválido. Digite apenas números." -ForegroundColor Red
            }
            Pause
        }
        "8" {
            $obj = [PSCustomObject]@{
                Produtos           = [PSCustomObject]@{}
                LimiteEstoqueBaixo = $limiteEstoqueBaixo
            }
            foreach ($item in $produtos.GetEnumerator()) {
                $obj.Produtos | Add-Member -NotePropertyName $item.Key -NotePropertyValue $item.Value
            }
            $obj | ConvertTo-Json -Depth 5 | Set-Content $arquivoProdutos
            Write-Host "Dados salvos em $arquivoProdutos" -ForegroundColor Cyan
        }
        "9" {
            $nome = Read-Host "Digite o nome do produto que deseja alterar a validade"
            if ($produtos.ContainsKey($nome)) {
                $novaValidade = Read-Host "Digite a nova validade (ou deixe em branco para remover) - Formato: dd/MM/yyyy"
                if ($novaValidade) {
                    $produtos[$nome].Validade = $novaValidade
                } else {
                    $produtos[$nome].Validade = $null
                }
                $produtos[$nome].UltimaAlteracao = (Get-Date -Format "dd/MM/yyyy HH:mm")
                Write-Host "Validade alterada com sucesso!" -ForegroundColor Green
            } else {
                Write-Host "Produto não encontrado." -ForegroundColor Red
            }
            Pause
        }
        "10" {
            $dias = Read-Host "Digite o número de dias para verificar validade (ex: 7)"
            $hoje = Get-Date
            $limite = $hoje.AddDays([int]$dias)

            $produtosComValidade = $produtos.GetEnumerator() | Where-Object { $_.Value.Validade }
            if (-not $produtosComValidade) {
                Write-Host "Nenhum produto possui validade registrada." -ForegroundColor Yellow
            } else {
                Write-Host "`n=== Produtos próximos da validade (até $dias dias) ==="
                foreach ($item in $produtosComValidade) {
                    try {
                        $dataValidade = [datetime]::ParseExact($item.Value.Validade, "dd/MM/yyyy", $null)
                        if ($dataValidade -lt $hoje) {
                            Write-Host "❌ [$($item.Key)] - VENCIDO em $($item.Value.Validade)" -ForegroundColor Red
                        } elseif ($dataValidade -le $limite) {
                            Write-Host "⚠️ [$($item.Key)] - Vence em $($item.Value.Validade)" -ForegroundColor Yellow
                        }
                    } catch {
                        Write-Host "[$($item.Key)] - Validade inválida: $($item.Value.Validade)" -ForegroundColor Magenta
                    }
                }
            }
            Pause
        }
        Default {
            Write-Host "Opção inválida." -ForegroundColor Red
            Pause
        }
    }
} while ($opcao -ne "8")
