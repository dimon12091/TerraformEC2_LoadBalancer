#On Windows,  running commands into a privileged shell
Start-Service -Name Winrm
Enable-PSRemoting -Force
Set-ExecutionPolicy RemoteSigned -force
set-item wsman:localhost\client\trustedhosts -value * -force 
Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener $true
$User = "Administrator"
$PWord = ConvertTo-SecureString -String "u6QCH7FC7Q4%U*y46@m3KEaWeb$j.7kC" -AsPlainText -Force
$creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
#Access denied
$sess = New-PSSession -Credential $creds -ComputerName "3.16.186.98" 
Enter-PSSession $sess


#Exit-PSSession
#Remove-PSSession $sess