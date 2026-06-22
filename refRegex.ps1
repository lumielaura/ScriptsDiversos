# Regex reference
# \d      Any digit (0-9)                                             \d{3} matches 123
# \w      Word character (alphanumeric & underscore)                  \w+ matches Server_1
# \s      Whitespace (spaces, tabs)                                   \s+ matches variable spacing
# .       Any single character (except a newline)                     c.t matches cat or cot
# ^       Start of a string / line                                    ^Error strings starting with "Error"
# $       End of a string / line                                      \.log$ strings ending with ".log"
# \       Escape character (turns an operator into literal text)      \. matches a literal period .

# ===============================

# Check Match
# -match
# Returns $true or $false and populates $Matches (Automatic)
"Server-01" -match "Server-\d\d"   # Returns $true
"server-01" -cmatch "Server-\d\d"  # Returns $false (due to lowercase 's')

# Index 0 holds the entire text matched.
# Index 1, 2, etc., hold specific captured groups ()
if ("Order #94827 processed" -match "Order #(\d+)") {
    $orderId = $Matches[1]
    Write-Output "Found Order ID: $orderId"
}
# Output: Found Order ID: 94827

'CN=Administrator,CN=Users,DC=wef,DC=com' -match 'CN=(\w+)'
# output: true

# ===============================

# Replace Text
# -replace
# Replaces occurrences of a pattern with a new string
# Format a phone number by stripping everything except digits
"123-456-7890" -replace "\D", "" # Output: 1234567890
"192.168.1.1Aquilo-Isso10.0.0.5" -replace "\D", ""  
# Output: 1921681110005 (Deixa apenas N°)
"192.168.1.1Aquilo-Isso10.0.0.5" -replace "\d", ""  
# Output: ...Aquilo-Isso... (Retira os N°)
"Apenas XFV 192.168.1.1Aquilo-Isso10.0.0.5" -replace "\w", ""  
# Output: ...Aquilo-Isso... (Retira os N°)
"Não vou 192.168.1.1Aquilo-Isso10.0.0.5" -replace "\W", ""  
# Output: ...Aquilo-Isso... (Retira os N°)

# Reorder names using capture groups
"John Smith" -replace "^(\w+)\s+(\w+)$", '$2, $1'
# Output: Smith, John

# Faz a substituição do primeiro item encontrado pelo $1, ou qualquer texto colocado nesta posição
'CN=Administrator,CN=Users,DC=wef,DC=com' -replace 'CN=(\w+).*','$1'
# Output: Administrator

$texto = "192.168.1.50"
$resultado = $texto -replace '\.\d+$', ''
Write-Host $resultado # Saída: 192.168.1

# ===============================

# Split String
# -split
$split = 'ejohnson@wef.com' -split '@'
Get-ADUser -Identify $split[0] -server $split[1]
$split[0] # ejohnson
$split[1] # wef.com

# Splits a string into an array using a regex delimiter
$text = "IP units are 192.168.1.1 and 10.0.0.5"
$pattern = "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"

$texto = "192.168.1.50"
$partes = $texto -split '\.'
$resultado = "$($partes[0]).$($partes[1]).$($partes[2])."
Write-Host $resultado # Saída: 192.168.1.

# Fetch all matches using the .NET framework
[regex]::Matches($text, $pattern).Value
# Output:
# 192.168.1.1
# 10.0.0.5

# ===============================

# Select-String
# I could use it to search a folder for all scripts that are using Active Directory cmdlets with the verbs Get and Set.
# [GS] is a character class, but simply put it means allow G or S as the first character.
Select-String -Pattern '[GS]et-AD\w+' -Path *.ps1 -List

$texto = "192.168.1.50"
$resultado = $texto.Substring(0, $texto.LastIndexOf('.') + 1)
Write-Host $resultado # Saída: 192.168.1.