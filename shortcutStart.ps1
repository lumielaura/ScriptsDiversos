# Define the path to the program you want to create a shortcut for
$ProgramPath = "C:\Program Files\YourProgram\YourProgram.exe" 

# Define the name of the shortcut file (e.g., "Your Program.lnk")
$ShortcutName = "Your Program.lnk"

# Define the target directory for the shortcut in the Start Menu
# This places the shortcut in the "All Apps" section for the current user.
$StartMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"

# Combine the path and name to get the full shortcut path
$ShortcutPath = Join-Path -Path $StartMenuPath -ChildPath $ShortcutName

# Create a WScript.Shell object
$WshShell = New-Object -ComObject WScript.Shell

# Create the shortcut object
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)

# Set the target path of the shortcut
$Shortcut.TargetPath = $ProgramPath

# (Optional) Set the working directory for the program
# $Shortcut.WorkingDirectory = "C:\Program Files\YourProgram\"

# (Optional) Set an icon for the shortcut (e.g., from the executable itself)
# $Shortcut.IconLocation = "$ProgramPath,0" 

# Save the shortcut
$Shortcut.Save()

Write-Host "Shortcut '$ShortcutName' created in the Start Menu."