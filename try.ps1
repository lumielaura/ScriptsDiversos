Try {
    # Attempt to get content from a file that might not exist
    $content = Get-Content -Path "$PSScriptRoot\lifeIntSec.txt" -ErrorAction Stop
    Write-Host "File content: $content" -ForegroundColor Cyan
}
Catch {
    # Handle the error if the file is not found
    Write-Host "Error: Could not read the file. $($_.Exception.Message)" -ForegroundColor DarkRed
}
Finally {
    # This message will always be displayed
    Write-Host "Operation complete." -ForegroundColor DarkCyan
}