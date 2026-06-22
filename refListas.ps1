# Arquivo de referencia para criação de listas e variáveis com valores  atribuidos no powershell

# Método 1 - Listas com valores [PSCustomObject] - recomendado para estruturas pequenas
# Cria uma lista vazia
$lista = @() # Cria uma matriz vazia

# Adiciona itens com os nomes "Nome" e "Cargo"
$lista += [PSCustomObject]@{ Nome = "Ana"; Cargo = "Engenheira" }
$lista += [PSCustomObject]@{ Nome = "Bruno"; Cargo = "Analista" }
$lista += 'Valor 3'
$lista += 'Valor 4'
$lista += [PSCustomObject]@{ Nome = "Anderson"; Cargo = "Assistente" }

# Acessa o valor pelo nome da propriedade
$lista[0].Nome # Retorna: Ana
$lista[1].Cargo # Retorna: Analista
$lista[2]
$lista[2] = 'Valor 5'
Write-Host $lista
Write-Host ('=' * 60) # Barra
$lista.Count # lista a quantidade de itens que uma matriz tem

# Método 2 - Tabelas Hash ([Hashtable] ou [Dictionary])
# Muito usado para reutilizar parâmetros de comandos, traduzir linguagem de máquina em nomes legíveis sem precisar usar vários if/else
# Usa mapeamento de chave = valor
# Criação da tabela hash
$servidor = @{
    Nome  = 'Servidor-01'
    Status = 'Ativo'
    Porta  = 8080
}

# Mudança de valor usando colchetes (Forma mais segura/comum)
$servidor['Status'] = 'Manutenção'

# Mudança de valor usando notação de ponto
$servidor.Porta = 9090

Write-Host $servidor
#######
$minhaTabela = @{ Chave = 'Valor' } # Criar
$minhaTabela['NovaChave'] = 'NovoValor' # Adicionar/Alterar
$minhaTabela['Chave'] # Ler
$minhaTabela.Remove('Chave') # Remover
Write-Host ('=' * 60) # Barra


# Método 3 - Listas .NET - melhor para scripts complexos com grande quantidade de itens. Se a ordem não importar usar esse método
# Cria uma lista de strings
$minhaLista = [System.Collections.Generic.List[string]]::new()

# Adiciona itens
$minhaLista.Add("Servidor01")
$minhaLista.Add("Servidor02")
$minhaLista.Add("Servidor03")
$minhaLista.Add('Item0') # Adiciona um único item
# $minhaLista.AddRange(@('Item1', 'Item2')) # Adiciona múltiplos itens
Write-Host $minhaLista

# Remove um item específico pelo nome
$minhaLista.Remove("Servidor02")
$minhaLista.RemoveAt(0) # Remove o item na posição especificada
$minhaLista.RemoveAll({ param($_) $_ -eq 'Item2' }) # Remove todos que correspondem a um critério

# Verifica se um item está na lista (retorna $True ou $False)
$minhaLista.Contains("Servidor01")

# Filtrar e buscar dados
$minhaLista | Where-Object { $_ -like 'Item*' }
$minhaLista.FindAll({ param($_) $_ -like 'Item*' })
$minhaLista.Contains('Item1') # Retorna $true se o item existir

# Descobre a posição (index) de um item
$posicao = $minhaLista.IndexOf("Servidor03")
Write-Host $posicao

# Insere o item na posição 1, empurrando os outros para frente
$minhaLista.Insert(1, "ServidorNovo")

Write-Host ('=' * 60) # Barra

# Percorre toda a lista
foreach ($item in $minhaLista) {
    Write-Host "Item atual: $item"
}

$minhaLista.Clear() # Remove todos os elementos, mantendo a capacidade da lista alocada na memória