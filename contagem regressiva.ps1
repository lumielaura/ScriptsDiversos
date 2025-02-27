# operadores de comparação
# Igualdade

# -eq, -ieq, -ceq - é igual a
# -ne, -ine, -cne - não é igual a
# -gt, -igt, -cgt - maior que
# -ge, -ige, -cge - maior ou igual
# -lt, -ilt, -clt - inferior a
# -le, -ile, -cle - menor ou igual

# for ( valor inicial; condição; incremento)
# condição: valor menor ou igual a 10
for($i = 1; $i -le 10; $i++)
{
    Write-Host $i
}

"";
# condição: valor menor que 10
for ($i = 1
    $i -lt 10
    $i++){
    $i
}

"";
# incremento: de 2 em 2
for ($i = 0; $i -le 20; $i += 2)
{
    Write-Host $i
}

"";
# contador regressivo
# condição: maior ou igual
for($i = 10; $i -ge 0; $i--)
{
    Write-Host $i
    Start-Sleep -Seconds 1
}