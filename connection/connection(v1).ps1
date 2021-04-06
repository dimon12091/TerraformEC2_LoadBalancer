#On Windows,  running commands into a privileged shell
Start-Service -Name Winrm
set-item wsman:localhost\client\trustedhosts -value * -force 
Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener $true
Enter-PSSession -ComputerName “x.x.x.x” -Credential $(Get-Credential)