$letrasArray = 'a','b','c','d'
foreach ($letras in $letrasArray)
{
    Write-Host $letras
}

foreach ($file in Get-ChildItem) #-Path "$HOME\Pictures")
{
    if ($file.Length -gt 100KB)
    {
        Write-Host $file
        Write-Host $file.Length
        Write-Host $file.CreationTime
        ""
    }
}
# for more information put a format-list on the command

$i = 0
foreach ($file in Get-ChildItem -Path "$HOME\Pictures") {
    if ($file.Length -gt 5000KB) {
        Write-Host $file 'file size:' (($file.Length / 1024) /1024).ToString('F0') MB
        $i = $i + 1
        }
    }

    if ($i -ne 0) {
        Write-Host
        Write-Host $i ' file(s) over 5 MB in the current directory.'
    }
else {
    Write-Host 'No files greater than 5 MB in the current directory.'
}