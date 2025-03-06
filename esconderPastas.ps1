# Esconder arquivos
# gci -r $folder | % { $_.Attributes = $_.Attributes -bor "Hidden" }
# alternatively
Get-ChildItem -Recurse $folder | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }

# Ver arquivos novamente
# -force é necessario apenas para listar arquivos escondidos
# gci -r -fo $folder | % { $_.attributes -bor "Hidden" -bxor  "Hidden" }