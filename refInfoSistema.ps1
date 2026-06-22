Write-Host "Todas as informações detalhadas no computador" -ForegroundColor Blue
# Get-ComputerInfo 

Write-Host "Todas as informações resumidas do computador" -ForegroundColor Blue
# systeminfo

# =======================
# Informações de Hardware
# =======================
Write-Host "# Processador:" -ForegroundColor Blue
Get-CimInstance Win32_Processor | Format-List Name, Manufacturer, NumberOfCores, MaxClockSpeed
Write-Host "`n# Memória RAM:" -ForegroundColor Blue
Get-CimInstance Win32_PhysicalMemory | Format-List Manufacturer, Capacity, Speed, ConfiguredClockSpeed
Write-Host "`n# Placa de Vídeo:" -ForegroundColor Blue
Get-CimInstance Win32_VideoController | Format-List Name, AdapterRAM, DriverVersion
Write-Host "`n# Disco Rígido (Armazenamento):" -ForegroundColor Blue
Get-CimInstance Win32_DiskDrive | Format-List Model, Size, InterfaceType
Write-Host "`n# Placa-Mãe:" -ForegroundColor Blue
Get-CimInstance Win32_BaseBoard | Format-List Manufacturer, Product, SerialNumber
Write-Host "`n# Placa de Rede:" -ForegroundColor Blue
Get-CimInstance Win32_NetworkAdapter | Where-Object {$_.NetConnectionStatus -eq 2} | Format-List Name, MACAddress, Speed



# =======================
# Informações de sofware
# =======================

