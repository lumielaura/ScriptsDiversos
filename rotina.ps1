# Rotina que limpa todo o lixo eletronico peridioticamente - Win10

$VerbosePreference = "Continue";

# Limpando as pastas
# TEMP, %TEMP%, Prefetch
"C:\Windows\Temp",
"$HOME\AppData\Local\Temp",
"C:\Windows\Prefetch" |
ForEach-Object -Process {

    Get-ChildItem -Path $_ -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue;

}

Clear-RecycleBin -Force;

# Listando os itens nao apagados
"C:\Windows\Temp",
"$HOME\AppData\Local\Temp",
"C:\Windows\Prefetch" |
ForEach-Object -Process {

    Get-ChildItem -Path $_ -Recurse | Select-Object -Property name;

}