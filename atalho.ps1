# Criando Atalhos pelo Powershell
$objeto = New-Object -ComObject wscript.shell
$atalho = $objeto.CreateShortcut("$HOME\Desktop\CalcTest.lnk")
# Se o caminho já estiver registrado no Path é só usar o nome, caso contrário coloque o caminho completo do arquivo
$atalho.targetpath = 'Calc'
# Opcional
# $Shortcut.IconLocation = "C:\caminho\icone.ico"
$atalho.save()
