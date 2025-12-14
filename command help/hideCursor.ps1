# Hide the cursor
[Console]::CursorVisible = $false

#
# Your script logic goes here (e.g., progress bar, long-running operation)
#
"The cursor will be hidden for 5 seconds. `nDo not press CTRL+C before the code is complete, `nor your cursor will remain in my hands forever. :D"
Start-Sleep -Seconds 5


# Restore the cursor
[Console]::CursorVisible = $true
