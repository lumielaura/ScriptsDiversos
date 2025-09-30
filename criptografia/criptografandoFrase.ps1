function getKey($passPhrase) {
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($passPhrase)
    return $sha256.ComputeHash($bytes)
}

function encryptMessage {
    param(
        [string]$message,
        [string]$passPhrase
    )

    $key = getKey $passPhrase

    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $key
    $aes.GenerateIV()

    $encryptor = $aes.CreateEncryptor()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($message)
    $cipher = $encryptor.TransformFinalBlock($bytes, 0, $bytes.Length)

    $result = $aes.IV + $cipher
    return [Convert]::ToBase64String($result)
}

function decryptMessage {
    param(
        [string]$cipherText,
        [string]$passPhrase
    )

    $key = getKey $passPhrase
    $data = [Convert]::FromBase64String($cipherText)

    $iv = $data[0..15]
    $cipher = $data[16..($data.Length-1)]

    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $key
    $aes.IV = $iv

    $decryptor = $aes.CreateDecryptor()
    $plain = $decryptor.TransformFinalBlock($cipher, 0, $cipher.Length)

    return [System.Text.Encoding]::UTF8.GetString($plain)
}

# ------------------- MENU -------------------
do {
    Clear-Host
    Write-Host "=============================="
    Write-Host "   MENU DE CRIPTOGRAFIA AES   "
    Write-Host "=============================="
    Write-Host "[1] Encriptar Mensagem"
    Write-Host "[2] Decriptar Mensagem"
    Write-Host "[0] Sair"
    Write-Host "=============================="
    $opcao = Read-Host "Escolha uma opção"

    switch ($opcao) {
        "1" {
            $msg = Read-Host "Digite a mensagem que deseja encriptar"
            $pass = Read-Host "Digite a frase secreta"
            $resultado = encryptMessage -message $msg -passPhrase $pass
            Write-Host "`nMensagem encriptada:"
            Write-Host $resultado -ForegroundColor Cyan

            $salvar = Read-Host "`nDeseja salvar em arquivo? (s/n)"
            if ($salvar -eq "s") {
                $nomeArquivo = Read-Host "Digite o nome do arquivo (ex: mensagem)"
                $caminho = Join-Path $PSScriptRoot "$nomeArquivo.txt"
                $resultado | Out-File -FilePath $caminho -Encoding UTF8
                Write-Host "Mensagem encriptada salva em $caminho" -ForegroundColor Green
            }
            Pause
        }
        "2" {
            Get-ChildItem $PSScriptRoot -Name -Filter *.txt
            $cripto = Read-Host "Cole a mensagem encriptada (ou informe o nome do arquivo)"
            
            $caminhoArquivo = Join-Path $PSScriptRoot "$cripto.txt"
            if (Test-Path $caminhoArquivo) {
                $cripto = Get-Content $caminhoArquivo -Raw
            }

            $pass = Read-Host "Digite a frase secreta"
            try {
                $texto = decryptMessage -cipherText $cripto -passPhrase $pass
                Write-Host "`nMensagem decriptada:"
                Write-Host $texto -ForegroundColor Green

                $salvar = Read-Host "`nDeseja salvar em arquivo? (s/n)"
                if ($salvar -eq "s") {
                    $nomeArquivo = Read-Host "Digite o nome do arquivo (ex: mensagem_original)"
                    $caminho = Join-Path $PSScriptRoot "$nomeArquivo.txt"
                    $texto | Out-File -FilePath $caminho -Encoding UTF8
                    Write-Host "Mensagem decriptada salva em $caminho" -ForegroundColor Green
                }
            } catch {
                Write-Host "`nErro: não foi possível decriptar. Frase incorreta ou texto inválido." -ForegroundColor Red
            }
            Pause
        }
        "0" {
            Write-Host "`nSaindo..."
        }
        Default {
            Write-Host "`nOpção inválida. Tente novamente." -ForegroundColor Yellow
            Pause
        }
    }
} while ($opcao -ne "0")
