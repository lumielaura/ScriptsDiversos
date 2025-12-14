$trace = Test-Connection -IPv4 8.8.8.8 -Traceroute -TimeoutSeconds 1 | Select-Object -Property Hop,Hostname,Latency,Status | Format-Table
$calcTrace = $trace | Measure-Object -Line | Select-Object -ExpandProperty Lines
$resCalcTrace = ($calcTrace - 4)/3

"Total de Hops: $resCalcTrace" # De um trace sucessfull