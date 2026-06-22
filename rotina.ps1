# Atualizar todos os programas
winget upgrade --all --accept-source-agreements --accept-package-agreements

# Rotina que limpa todo o lixo eletronico peridioticamente
try {
    # Removendo regra do firewall
    if (Get-NetFirewallRule -DisplayName "*allow*" -OutVariable disableAllow) {
        Remove-NetFirewallRule -DisplayName "*allow*"
    }

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
            Write-Host "Removendo $($removerArquivos.Count) arquivos encontrados em ($_)." -ForegroundColor Yellow
        }
    }    
}
finally {
    # Listando os itens não apagados
    "$env:SystemRoot\Temp",
    "$env:TEMP",
    "$env:SystemRoot\Prefetch" |
    ForEach-Object -Process {    
        # Obter os arquivos (sem incluir subpastas)
        $arquivos = Get-ChildItem -Path $_ -File
        
        # Se houver arquivos, exibe quantidade e nomes
        if ($arquivos.Count -gt 0) {
            Write-Host "`nRestaram $($arquivos.Count) arquivos no diretório ($_)`nEles estão sendo usados e não podem ser apagados neste momento.`n" -ForegroundColor Yellow
            # $arquivos | ForEach-Object { Write-Output $_.FullName }
        }
    }
    
    # Avisa que regra de firewall foi removida
    if ($disableAllow.Count -gt 0) {
        Write-Host "`nForam removidas $($disableAllow.Count) regras 'allow 9009' do firewall.`n" -ForegroundColor Red
    }

    # Limpando a Lixeira (Não funciona com versão antiga do pswd)
    Clear-RecycleBin -Force;

    # Mensagem Final
    Write-Host "`nO processo de limpeza foi concluido." -ForegroundColor Cyan
}

# ideias para script : fazer um status de antes e depois, principalmente sobre o espaço liberado.
