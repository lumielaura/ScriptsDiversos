# Ciar texto encriptografado para usar posteriormente
$caminho = "$PSScriptRoot\criptoSenha.txt";
Read-Host -AsSecureString | ConvertFrom-SecureString | Out-File $caminho