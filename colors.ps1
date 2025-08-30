# Mostrar cores
[enum]::GetValues([System.ConsoleColor]) | Foreach-Object {Write-Host $_ -ForegroundColor $_}

Write-Host "Brincando com as cores:" -NoNewline
Write-Host ' Aviso Perigo' -ForegroundColor DarkRed -NoNewline
Write-Host ' Mas aqui voce esta seguro' -ForegroundColor Green -NoNewline
Write-Host ' Mentira, agora sim voce esta acabado' -ForegroundColor Black -NoNewline