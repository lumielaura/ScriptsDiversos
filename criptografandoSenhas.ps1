# Ciar texto encriptografado para usar posteriormente
$caminho = "$HOME\Documents\GitHub\ScriptsDiversos\senha.txt";
Read-Host -AsSecureString | ConvertFrom-SecureString | Out-File $caminho