#On Windows,  running commands into a privileged shell
Start-Service -Name Winrm
Set–Item WSMan:\localhost\Client\TrustedHosts –Value “*”
Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener $true
Enter-PSSession -ComputerName “x.x.x.x” -Credential $(Get-Credential)