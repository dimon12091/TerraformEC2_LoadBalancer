<powershell>
Enable-NetFirewallRule -All
New-Item -ItemType Directory -Name 'MyWebsite' -Path 'C:\'
New-Item -ItemType File -Name 'index.html' -Path 'C:\MyWebsite\'
Add-Content -Path 'C:\MyWebsite\index.html'  -Value '<p>Thank you for reading this post on how to administer IIS with PowerShell!</p>'
New-IISSite -Name 'MyWebsite' -PhysicalPath 'C:\MyWebsite\' -BindingInformation "*:80:"
</powershell>