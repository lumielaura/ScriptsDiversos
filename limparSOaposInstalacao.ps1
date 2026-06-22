# Desinstalar bloaters que vem com SO

$ind=0 #index

"Quick Assist",
"Dev Home",
"Microsoft Edge para Game Bar",
"Microsoft To Do",
"Notícias",
"MSN Clima",
"Notas Autoadesivas da Microsoft",
"Power Automate",
"Solitaire & Casual Games",
"Microsoft Bing",
"Obter Ajuda",
"Hub de Comentários",
"Microsoft OneDrive",
"Microsoft Clipchamp",
"Xbox",
"Game Speech Window",
"Xbox TCUI",
"Xbox Identity Provider" |
ForEach-Object -Process {    
    $ind++
    Write-Host "`nNome: $ind`tName: $_"
    winget uninstall "$_"
}


# "Game Bar" - não desinstalar esse item