# Atualizando o arquivo de ip do rainmetter
Get-NetIPAddress -InterfaceIndex 13 -AddressFamily IPv4 | Select-Object -ExpandProperty IPAddress > "C:\Program Files\Rainmeter\Misc\ipconf"