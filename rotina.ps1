# Rotina que limpa todo o lixo eletronico peridioticamente
$VerbosePreference = "Continue";

# Limpando as pastas
# TEMP, %TEMP%, Prefetch
"$env:SystemRoot\Temp",
"$env:TEMP",
"$env:SystemRoot\Prefetch" |
ForEach-Object -Process {
    Get-ChildItem -Path $_ -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue;
}

# Limpando a Lixeira 
Clear-RecycleBin -Force;

Write-Output "`n...O processo de limpeza foi concluido...`n"

# Listando os itens nao apagados
"$env:SystemRoot\Temp",
"$env:TEMP",
"$env:SystemRoot\Prefetch" |
ForEach-Object -Process {
    
    # Obtém os arquivos (sem incluir subpastas)
    $arquivos = Get-ChildItem -Path $_ -File
    
    # Se houver arquivos, exibe quantidade e nomes
    if ($arquivos.Count -gt 0) {
        Write-Output "`nArquivos encontrados em ($_): $($arquivos.Count)`n"
        $arquivos | ForEach-Object { Write-Output $_.FullName }
    }
}

# ideias para script : fazer um status de antes e depois, principalmente sobre o espaço liberado.