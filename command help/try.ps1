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


# PowerShell uses try, catch, and an optional finally block for structured exception handling of terminating errors. The try block encloses code that might cause an error, the catch block handles the exception if one occurs, and the finally block runs regardless, often for cleanup
# terminating errors
try {
    # Code that might produce a terminating error
    # e.g., operations with files, network, or invalid inputs
}
catch {
    # Code to handle the error
    Write-Host "An error occurred: $($_)"
    # Access error details using the automatic variable $_ or $PSItem
}
finally {
    # [Optional] Code that always runs, regardless of whether an error occurred or not
    # Use this for cleanup tasks, such as closing file streams or network connections
    Write-Host "Execution completed."
}

# By default, most PowerShell cmdlet errors are non-terminating, meaning the script displays an error message but continues running, which bypasses the catch block. 
# To force a non-terminating error into a terminating one that can be caught, you must use the -ErrorAction Stop common parameter on the specific command within the try block

# Non-Terminating Errors
$directoryPath = "C:\NonExistentFolder"

try {
    # The -ErrorAction Stop parameter forces a terminating error if the path is not found
    Get-ChildItem -Path $directoryPath -ErrorAction Stop
    Write-Host "Directory found."
}
catch {
    # This block will now catch the error
    Write-Host "Error: The directory '$directoryPath' was not found."
}

# Alternatively, you can set the global preference variable $ErrorActionPreference = "Stop" at the beginning of your script to make all non-terminating errors terminating errors. 

# Catching Specific Exceptions
# Multiple catch blocks can be used to handle different exception types for more tailored error responses. It's recommended to list the most specific exception types first. Inside the catch block, the automatic variable $_ (or $PSItem) contains the ErrorRecord object, providing details like $_.Exception.Message or $_.ScriptStackTrace.