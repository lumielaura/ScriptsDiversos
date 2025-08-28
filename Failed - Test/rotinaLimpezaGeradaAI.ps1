# Executar como Administrador
# Otimização do Windows 11 com ponto de restauração
# (Script em fase de teste)

function Show-Info($msg) {
    Write-Host "[INFO] $msg" -ForegroundColor Cyan
}

# Criar ponto de restauração
Show-Info "Criando ponto de restauração do sistema..."
Enable-ComputerRestore -Drive "C:\"
Checkpoint-Computer -Description "Limpeza e Otimização do Windows 11" -RestorePointType "MODIFY_SETTINGS"

# Limpar arquivos temporários
Show-Info "Limpando arquivos temporários..."
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# Limpar cache do Windows Update
Show-Info "Limpando cache do Windows Update..."
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Stop-Service -Name bits -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service -Name wuauserv
Start-Service -Name bits

# Resetar cache da Microsoft Store
Show-Info "Resetando Microsoft Store..."
Start-Process "wsreset.exe" -WindowStyle Hidden -Wait

# Remover apps pré-instalados desnecessários
Show-Info "Removendo aplicativos pré-instalados..."
$apps = @(
    "Microsoft.XboxGamingOverlay",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.People",
    "Microsoft.BingNews",
    "Microsoft.BingWeather",
    "Microsoft.MicrosoftSolitaireCollection"
)
foreach ($app in $apps) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq $app} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

# Desabilitar tarefas agendadas
Show-Info "Desabilitando tarefas agendadas..."
$tasks = @(
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "\Microsoft\Windows\Autochk\Proxy",
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
)
foreach ($task in $tasks) {
    Disable-ScheduledTask -TaskPath $task -ErrorAction SilentlyContinue
}

# Desabilitar serviços opcionais
Show-Info "Desabilitando serviços desnecessários..."
$services = @("DiagTrack", "dmwappushservice", "Fax", "RemoteRegistry")
foreach ($svc in $services) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled
}

# Executar limpeza de disco silenciosamente
Show-Info "Executando limpeza de disco silenciosamente..."
$cleanMgrFile = "$env:TEMP\cleanmgr.xml"
@"
<?xml version="1.0"?>
<DiskCleanup>
  <State>
    <Option>
      <Volume>C:</Volume>
      <FileID>Temporary Setup Files</FileID>
      <State>1</State>
    </Option>
    <Option>
      <Volume>C:</Volume>
      <FileID>Temporary Files</FileID>
      <State>1</State>
    </Option>
    <Option>
      <Volume>C:</Volume>
      <FileID>System error memory dump files</FileID>
      <State>1</State>
    </Option>
  </State>
</DiskCleanup>
"@ | Set-Content -Path $cleanMgrFile

cleanmgr.exe /sagerun:1 | Out-Null

# Conclusão
Show-Info "Limpeza e otimização finalizadas. É recomendável reiniciar o computador."
