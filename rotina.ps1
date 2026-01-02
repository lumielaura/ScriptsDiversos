# Rotina que limpa todo o lixo eletronico peridioticamente

# Limpando as pastas
# TEMP, %TEMP%, Prefetch
"$env:SystemRoot\Temp",
"$env:TEMP",
"$env:SystemRoot\Prefetch" |
ForEach-Object -Process {
    # Removendo arquivos acumulados nesses diretorios
    Get-ChildItem -Path $_ -Recurse -OutVariable removerArquivos | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue;

    # Se houver arquivos ele ira dizer a quantidade de arquivos a serem removidos
    if ($removerArquivos.Count -gt 0) {
        Write-Output "Removendo $($removerArquivos.Count) arquivos encontrados em ($_)."
    }
}

# Limpando a Lixeira 
Clear-RecycleBin -Force;
Write-Output "`n`nO processo de limpeza foi concluido.`nVerificando restos de arquivos...`n"

# Listando os itens não apagados
"$env:SystemRoot\Temp",
"$env:TEMP",
"$env:SystemRoot\Prefetch" |
ForEach-Object -Process {    
    # Obter os arquivos (sem incluir subpastas)
    $arquivos = Get-ChildItem -Path $_ -File
    
    # Se houver arquivos, exibe quantidade e nomes
    if ($arquivos.Count -gt 0) {
        Write-Output "`nRestaram $($arquivos.Count) arquivos no diretório ($_)`nEles estao sendo usados e não podem ser apagados neste momento.`n"
        # $arquivos | ForEach-Object { Write-Output $_.FullName }
    }
}

# Removendo essa regra estranha do firewall
if (Get-NetFirewallRule -DisplayName "*allow*" -OutVariable disableAllow) {
    Write-Output "`nForam removidas $($disableAllow.Count) regras 'allow 9009' do firewall.`n"
    Remove-NetFirewallRule -DisplayName "*allow*"
}

# ideias para script : fazer um status de antes e depois, principalmente sobre o espaço liberado.