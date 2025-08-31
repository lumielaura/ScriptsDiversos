# Imprimindo todas as variaveis de ambiente
Get-ChildItem ENV:

# Mostra apenas as ocorrencias com este exato nome
Get-ChildItem ENV: | Where-Object {$_.Name -match "^PATH$|^USERNAME$|^TEMP$"}

# Mostra todas as ocurrencias com esses nomes
Get-ChildItem ENV: | Where-Object {$_.Name -match "PATH|TEMP" }

# Fazendo pesquisa que atende aos dois itens
Get-ChildItem ENV: | Where-Object {$_.Name -match "^PATH$|^TEMP$" , "*File" } | Format-Table -Wrap

# =================================
# Caracters usados com o "-match"
# =================================
# ^ Defini o inicio do nome
# $ Defini o final do nome
# | Divide as Palavras que podem ser pesquisadas
# * qualquer caractere pode entrar nesta posição

