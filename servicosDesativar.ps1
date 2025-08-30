# Lista de serviços que geralmente podem ser desativados
$servicos = @(
    "Fax",
    "bthserv",               # Bluetooth Support Service
    "RemoteRegistry",
    "seclogon",              # Secondary Logon
    "SCardSvr",              # Smart Card
    "PrintSpooler",          # Spooler de Impressão
    "WerSvc",                # Windows Error Reporting
    "TermService",           # Remote Desktop Services
    "WbioSrvc",              # Windows Biometric Service
    "TabletInputService",    # Tablet PC Input
    "RetailDemo",            # Retail Demo Service
    "SessionEnv",            # Remote Desktop Configuration
    "MapsBroker",            # Downloaded Maps Manager
    "wisvc"                  # Windows Insider Service
)

Write-Host "=== Serviços raramente usados encontrados no sistema ===`n"

# Exibir status atual
Get-Service -Name $servicos -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "Serviço     : " -NoNewline
    Write-Host "$($_.DisplayName)" -ForegroundColor DarkYellow
    Write-Host "Nome        : $($_.Name)"
    Write-Host "Status      : " -NoNewline
    if ($_.Status -eq "Running"){
        Write-Host "$($_.Status)" -ForegroundColor Green
    } elseif ($_.Status -eq "Stopped"){
        Write-Host "$($_.Status)" -ForegroundColor Red
    } else {
        Write-Host "$($_.Status)" -ForegroundColor Gray
    }
    Write-Host "StartType   : " -NoNewline
    if ($_.StartType -eq "Disabled") {
        Write-Host "$($_.StartType)" -ForegroundColor Red
    } elseif ($_.StartType -eq "Manual") {
        Write-Host "$($_.StartType)" -ForegroundColor Gray
    } else {
        Write-Host "$($_.StartType)" -ForegroundColor Green
    }
    # Write-Host "Descrição : $($_.Description)"
    Write-Host "------"
}

Write-Host "`nOpções:"
Write-Host "1 - Colocar todos como Manual"
Write-Host "2 - Desativar todos"
Write-Host "3 - Escolher individualmente"
$escolha = Read-Host "Digite a opção desejada"

switch ($escolha) {
    "1" {
        foreach ($s in $servicos) {
            Set-Service -Name $s -StartupType Manual -ErrorAction SilentlyContinue
        }
        Write-Host "✅ Todos configurados como Manual"
    }
    "2" {
        foreach ($s in $servicos) {
            Set-Service -Name $s -StartupType Disabled -ErrorAction SilentlyContinue
        }
        Write-Host "✅ Todos Desativados"
    }
    "3" {
        foreach ($s in $servicos) {
            $svc = Get-Service -Name $s -ErrorAction SilentlyContinue
            if ($null -ne $svc) {
                Write-Host "`nServiço encontrado: " -NoNewline
                Write-Host "$($svc.DisplayName)" -NoNewline -ForegroundColor DarkYellow
                Write-Host " (" -NoNewline
                if ($svc.Status -eq "Running"){
                    Write-Host "$($svc.Status)" -NoNewline -ForegroundColor Green
                } elseif ($svc.Status -eq "Stopped"){
                    Write-Host "$($svc.Status)" -NoNewline -ForegroundColor Red
                } else {
                    Write-Host "$($svc.Status)" -NoNewline -ForegroundColor Gray
                }
                Write-Host " - StartType: " -NoNewline
                if ($svc.StartType -eq "Disabled") {
                    Write-Host "$($svc.StartType)" -NoNewline -ForegroundColor Red
                } elseif ($svc.StartType -eq "Manual") {
                    Write-Host "$($svc.StartType)" -NoNewline -ForegroundColor Gray
                } else {
                    Write-Host "$($svc.StartType)" -NoNewline -ForegroundColor Green
                }
                Write-Host ")`nDescrição: `n$($svc.Description)"
                $op = Read-Host "`nDigite [M]anual, [D]esativar ou [N]ão alterar"
                switch ($op.ToUpper()) {
                    "M" { Set-Service -Name $s -StartupType Manual; Write-Host "➡ Alterado para Manual" -ForegroundColor Gray }
                    "D" { Set-Service -Name $s -StartupType Disabled; Write-Host "➡ Desativado" -ForegroundColor Red }
                    default { Write-Host "⏭ Nenhuma alteração" }
                }
            }
        }
    }
    default { Write-Host "❌ Opção inválida, nada foi alterado." -ForegroundColor Red}
}
