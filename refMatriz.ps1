param (
    [string]
    $nome,
    
    [string]
    $sexo,

    [string]
    $cargo
)

# Cria uma matriz vazia | Importante sempre fazer isso antes de adicionar os dados ou a matriz pode não funcionar corretamente
$lista = @() 

# Importa dados de JSON
$lista = Get-Content -Path "$PSScriptRoot\refMatrizContent.json"  | ConvertFrom-Json

# Adicionar entrada inicial com os valores corretos
if ($nome -and $sexo -like "?" -and $cargo ) {
    # Adicionar nome a lista
    $lista += [PSCustomObject]@{ Nome = "$nome"; Sexo = "$sexo" ; Cargo = "$cargo" }
    # Achar index do nome adicionado
    $IdNome = $lista.IndexOf("$nome")
    # Mensagem 
    Write-Host "$($lista[$IdNome].Nome) foi adicionado com sucesso!"
}

# Exporta matriz para JSON
$lista | ConvertTo-Json | Set-Content -Path "$PSScriptRoot\refMatrizContent.json"

# Lista completa
# $lista

Write-Host "`nFrases usando os dados gravados no arquivo json.`n"
# Frase de acordo com o sexo
0..($lista.Length-1) | ForEach-Object {
    if ($lista[$_].Sexo -eq "M") { # Masculino
        Write-Host "$($lista[$_].Nome) é um $($lista[$_].Cargo)"
    } elseif ($lista[$_].Sexo -eq "F") { # Feminino
        Write-Host "$($lista[$_].Nome) é uma $($lista[$_].Cargo)"
    } else { # Erro
        Write-Host "O Sexo de $($lista[$_].Nome) está errado!"
    }
}

# # Outras formas de adicionar itens na matriz
# # Adicionar usando variáveis
# $nome = "Ana"
# $cargo = "Engenheira"
# $sexo = "F"
# $lista += [PSCustomObject]@{ Nome = "$nome"; Sexo = "$sexo" ; Cargo = "$cargo" }

# # Adicionar usando custom object
# $lista += [PSCustomObject]@{ Nome = "Carlos"; Sexo = "M" ; Cargo = "Empresário" }
# $lista += [PSCustomObject]@{ Nome = "Júlio"; Sexo = "M" ; Cargo = "Pastor" }
