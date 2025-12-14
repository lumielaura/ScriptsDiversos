# Gerando uma animação das teclas no powershell
1..128 | ForEach-Object { Write-Host ($_,[char]$_) ; Start-Sleep -Milliseconds 100 }