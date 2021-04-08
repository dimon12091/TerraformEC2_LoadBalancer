<powershell>
Enable-NetFirewallRule -All
Import-Module ServerManager
Set-NetFirewallRule -Name “WINRM-HTTP-In-TCP-PUBLIC” -RemoteAddress “Any”
Enable-PSRemoting –force
</powershell>

