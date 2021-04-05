<powershell>
Enable-NetFirewallRule -All
Import-Module ServerManager
Import-Module WebAdministration
winrm quickconfig
Enable-PSRemoting –force
Set-Service WinRM -StartMode Automatic
winrm create winrm/config/Listener?Address=*+Transport=HTTP
Restart-Service WinRM
New-NetFirewallRule -Name PsRemotingHttp -Directory Inbound -Alow Allow -Protocol tcp -LocalPort 5985 -DisplayName PsRemotingHttp
winrm set winrm/config/client '@{TrustedHosts="10.216.2.145"}'
</powershell>
