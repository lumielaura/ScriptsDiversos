
param(
    [bool]$IsLightOn = $true,  # Default value is $true
    [int]$Number = 0,          # 
    [switch]$Loop,            # A switch parameter
    [switch]$Off            # A switch parameter
)

if ($IsLightOn) {
    Write-Host "Light is on."
} else {
    Write-Host "Light is off."
}

if ($Off) {
    Write-Host "The 'Off' switch was specified."
}

if ($Number -gt 0 -and $Loop) {
    Write-Host "The number of lights is Greater than 0 and the switch loop is 'ON'"
}

Write-Host "Start of an Loop."
do {
    Write-Host "Loop"
    Start-Sleep -Seconds 1
} while (
    $Loop
)
