###EACH SCRIPT CLEAN UP WEBSITE, SITE_FOLDER, APPLICATION POOL

#Clean up WebSite
Remove-IISSite -Name "Default Web Site" -Confirm:$false
Remove-IISSite -Name "GlobalSite" -Confirm:$false

#Clean up site folder
Remove-Item -Path "C:\GlobalSite" -Recurse

#Clean up Application Pool
Remove-WebAppPool -Name "GlobalAppPool"


