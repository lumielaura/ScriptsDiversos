# Teclas e Bips

$KeyCodes = @{
    Left  = 37
    Up    = 38
    Right = 39
    Down  = 40
    Esc   = 27
}
$Frequencies = @{
    Left  = 300
    Up    = 400
    Right = 500
    Down  = 600
}
$BeepDuration = 300
while ($true){
    $KeyPress = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").virtualkeycode
    if ($KeyPress -eq $KeyCodes.Esc){
        break
    }
    switch($KeyPress){
        $KeyCodes.Left  {
            [console]::Beep($Frequencies.Left, $BeepDuration)
            break
        }
        $KeyCodes.Up    {
            [console]::Beep($Frequencies.Up, $BeepDuration)
            break
        }
        $KeyCodes.Right {
            [console]::Beep($Frequencies.Right, $BeepDuration)
            break
        }
        $KeyCodes.Down  {
            [console]::Beep($Frequencies.Down, $BeepDuration)
            break
        }
    }
}