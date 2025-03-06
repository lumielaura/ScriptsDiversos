Write-Progress -Activity "Main Task" -Status "Task 1 of 3" -PercentComplete 33
# Task 1 logic
Start-Sleep -Seconds 3
"Aqui é o lugar onde eu quero ficar"

Write-Progress -Activity "Main Task" -Status "Task 2 of 3" -PercentComplete 66
# Task 2 logic
Start-Sleep -Seconds 3
"Aqui é o lugar onde eu nao vou"

Write-Progress -Activity "Main Task" -Status "Task 3 of 3" -PercentComplete 100
# Task 3 logic
Start-Sleep -Seconds 3

"Completei a minha tarefa"

$Items = 1..10000
 
Write-Progress -Activity "Processing Items" -Status "Starting" -PercentComplete 0
 
foreach ($Item in $Items) {
    $PercentComplete = (($Item / $Items.Count) * 100)
    $Status = "Processing Item $($Item)"
 
    Write-Progress -Activity "Processing Items" -Status $Status -PercentComplete $PercentComplete
 
    # Do some processing
}
 
Write-Progress -Activity "Processing Items" -Status "Complete" -PercentComplete 100


# Set total time for countdown timer
$timeRemaining = 20
 
while($timeRemaining -gt 0){
 
  # Calculate percentage
  $percentComplete = (($timeRemaining / 60) * 100)
 
  # Update progress bar
  Write-Progress -Activity "Deployment in progress" -Status "Time remaining: $timeRemaining seconds" -PercentComplete $percentComplete -SecondsRemaining $timeRemaining
 
  # Decrement timer
  $timeRemaining--
 
  # Wait 1 second
  Start-Sleep -Seconds 1
}

Function Start-Countdown {
  param (
      [Parameter(Mandatory=$true)]
      [int]$Seconds
  )

  # Countdown start time
  $StartTime = Get-Date
  $ElapsedTime =0

  # While there are still seconds left
  While ($ElapsedTime -lt $seconds) {
      # Calculate elapsed time
      $ElapsedTime = [math]::Round(((Get-Date) - $StartTime).TotalSeconds,0)
      
      # Update the progress bar
      Write-Progress -Activity "Counting down..." -Status ("Time left: " + ($Seconds - $ElapsedTime) + " seconds") -PercentComplete (($elapsedTime / $Seconds) * 100)
      #$Seconds = $Seconds - $elapsedTime

      # Wait for a second
      Start-Sleep -Seconds 1
  }

  # Once countdown is complete, close the progress bar
  Write-Progress -Activity "Counting down..." -Completed
}

# Call the function to start a 10-second countdown
Start-Countdown -Seconds 10


$progressParams = @{
  Activity = "Processing data"
  Status = "In progress"
  PercentComplete = 0
  SecondsRemaining = 60
  CurrentOperation = "Initializing"
}

Write-Progress @progressParams

$data = 1..10000
$index = 1
# Start the countdown timer
$timer = [Diagnostics.Stopwatch]::StartNew()

# Loop through the data and update the progress bar
foreach ($item in $data) {
  # Perform some operation on $item

  # Update the progress bar
  $progressParams.PercentComplete = ($index / $data.Count) * 100
  $progressParams.CurrentOperation = "Processing item $index of $($data.Count)"
  $progressParams.SecondsRemaining = (($timer.Elapsed.TotalSeconds / $index) * ($data.Count - $index)).ToString("F0")
  Write-Progress @progressParams

  $index++
}

# Complete the progress bar
Write-Progress -Completed -Activity "Completed"


$Collection = 1..100
ForEach ($Item in $Collection) {
  Write-Progress -PercentComplete ($Item/100*100) -Status "Processing Items" -Activity "Item $item of 100"
  # Your actual script logic here
  Start-Sleep -Milliseconds 50
}


for ($i = 1; $i -le 100; $i++ ) {
    Write-Progress -Activity "Search in Progress" -Status "$i% Complete:" -PercentComplete $i
    Start-Sleep -Milliseconds 250
}

$PSStyle.Progress.View = 'Classic'

foreach ( $i in 1..10 ) {
  Write-Progress -Id 0 "Step $i"
  foreach ( $j in 1..10 ) {
    Write-Progress -Id 1 -ParentId 0 "Step $i - Substep $j"
    foreach ( $k in 1..10 ) {
      Write-Progress -Id 2  -ParentId 1 "Step $i - Substep $j - iteration $k"
      Start-Sleep -Milliseconds 150
    }
  }
}


# Real exemplos de como usar a barra de progresso

$Files = Get-ChildItem -Path "C:\Source"
$Destination = "C:\Destination"
 
$TotalFiles = $Files.Count
$Count = 0
 
Write-Progress -Activity "Copying Files" -Status "Starting" -PercentComplete 0
 
foreach ($File in $Files) {
    $Count++
    $PercentComplete = (($Count / $TotalFiles) * 100)
    $Status = "Copying $($File.Name)"
 
    Write-Progress -Activity "Copying Files" -Status $Status -PercentComplete $PercentComplete
 
    Copy-Item $File.FullName $Destination -Force
}
 
Write-Progress -Activity "Copying Files" -Status "Complete" -PercentComplete 100



# exemplo 2
$Urls = @(
    "https://www.microsoft.com/downloads/SharePointSP1.msi",
    "https://www.microsoft.com/downloads/SharePointSP2.msi",
    "https://www.microsoft.com/downloads/SharePointSP3.msi"
)
 
# Destination folder
$destinationFolder = "C:\Downloads"
 
# Ensure the destination folder exists
if (-not (Test-Path $destinationFolder)) {
    New-Item -Path $destinationFolder -ItemType Directory
}

# Download each file
$totalUrls = $urls.Count
for ($i=0; $i -lt $totalUrls; $i++) {
    $url = $urls[$i]
    $fileName = [System.IO.Path]::GetFileName($url)  # Extract file name from URL
    $destinationPath = Join-Path -Path $destinationFolder -ChildPath $fileName
 
    # Display main progress
    Write-Progress -Activity "Downloading files" -Status ("Downloading " + $fileName) -PercentComplete (($i / $totalUrls) * 100)
 
    # Download file with sub-progress bar for individual file download
    Invoke-WebRequest -Uri $url -OutFile $destinationPath -Verbose
}
 
Write-Progress -Activity "Downloading files" -Completed -Status "All files downloaded!"
Write-Host "All files downloaded successfully!" -ForegroundColor Green