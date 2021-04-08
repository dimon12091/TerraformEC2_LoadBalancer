#On Windows,  running commands into a privileged shell
Start-Service -Name Winrm
Set-NetConnectionProfile 
Enable-PSRemoting -Force
Set-ExecutionPolicy RemoteSigned -force
set-item wsman:localhost\client\trustedhosts -value * -force 
Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener $true
$User = "Administrator"
$PWord = ConvertTo-SecureString -String "" -AsPlainText -Force
$creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
Enter-PSSession -ComputerName "" -Credential $creds