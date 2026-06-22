# # Tentativa 1
# $url = "https://temporalistl.wordpress.com/2024/03/24/ougon142"
# $html = (Invoke-RestMethod -Uri $url)
# $textoLimpo = [System.Web.HttpUtility]::HtmlDecode(([xml]$html).InnerText)
# Write-Output $textoLimpo


# # Tentativa 2
# $url = "https://temporalistl.wordpress.com/2024/03/24/ougon142"
# $webClient = New-Object System.Net.WebClient
# $html = $webClient.DownloadString($url)

# # Remove as tags HTML usando expressão regular
# $textoLimpo = [regex]::Replace($html, '<[^>]+>', '')
# # Limpa espaços em branco excessivos e quebras de linha
# $textoLimpo = [regex]::Replace($textoLimpo, '\s+', ' ')

# Write-Output $textoLimpo
