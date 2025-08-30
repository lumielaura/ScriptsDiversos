# Caminho dos arquivos para salvar os produtos
$arquivoProdutos = "$PSScriptRoot\produtos.json"
$arquivoCSV = "$PSScriptRoot\produtos.csv"

# Defina o limite de alerta de estoque baixo
$limiteEstoqueBaixo = 5

# Se o arquivo já existir, carrega os dados
if (Test-Path $arquivoProdutos) {
    $produtos = Get-Content $arquivoProdutos | ConvertFrom-Json
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
    Write-Host "7 - Salvar e sair"
    Write-Host ""
}

function mostrarProduto($nome, $quantidade) {
    if ($quantidade -le $limiteEstoqueBaixo) {
        Write-Host "[$nome]: $quantidade (ESTOQUE BAIXO!)" -ForegroundColor Red
    } else {
        Write-Host "[$nome]: $quantidade"
    }
}

do {
    mostrarMenu
    $opcao = Read-Host "Escolha uma opção"

    switch ($opcao) {
        "1" {
            $nome = Read-Host "Digite o nome do produto"
            $quantidade = Read-Host "Digite a quantidade"
            if ($produtos.ContainsKey($nome)) {
                Write-Host "Produto já existe. Use a opção 2 para alterar." -ForegroundColor Yellow
            } else {
                $produtos[$nome] = [int]$quantidade
                Write-Host "Produto adicionado com sucesso!" -ForegroundColor Green
            }
            Pause
        }
        "2" {
            $nome = Read-Host "Digite o nome do produto que deseja alterar"
            if ($produtos.ContainsKey($nome)) {
                $novaQtd = Read-Host "Digite a nova quantidade"
                $produtos[$nome] = [int]$novaQtd
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
            }
            Pause
        }
        "5" {
            if ($produtos.Count -eq 0) {
                Write-Host "Nenhum produto cadastrado para exportar." -ForegroundColor Yellow
            } else {
                $listaExport = foreach ($item in $produtos.GetEnumerator()) {
                    [PSCustomObject]@{
                        Produto    = $item.Key
                        Quantidade = $item.Value
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
            # Salva os dados em JSON
            $produtos | ConvertTo-Json | Set-Content $arquivoProdutos
            Write-Host "Dados salvos em $arquivoProdutos" -ForegroundColor Cyan
        }
        Default {
            Write-Host "Opção inválida." -ForegroundColor Red
            Pause
        }
    }
} while ($opcao -ne "7")
