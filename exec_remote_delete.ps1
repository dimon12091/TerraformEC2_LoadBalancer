#On Windows,  running commands into a privileged shell
$password1 = (terraform output -json instance_info | jq  -r '.[]' | Select-Object -Index 0)
$hostip1 = (terraform output -json instance_info_ips | jq  -r '.[]' | Select-Object -Index 0)
$password2 = (terraform output -json instance_info | jq  -r '.[]' | Select-Object -Index 1)
$hostip2 = (terraform output -json instance_info_ips | jq  -r '.[]' | Select-Object -Index 1)

$User = "Administrator"

$PWord1 = ConvertTo-SecureString -String $password1 -AsPlainText -Force
$creds1 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord1
Invoke-Command -ComputerName $hostip1 -Credential $creds1 -FilePath .\scripts\delete_site.ps1

$PWord2 = ConvertTo-SecureString -String $password2 -AsPlainText -Force
$creds2 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord2
Invoke-Command -ComputerName $hostip2 -Credential $creds2 -FilePath .\scripts\delete_site.ps1


