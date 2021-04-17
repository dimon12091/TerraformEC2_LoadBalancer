#Create website folder with file
New-Item -ItemType Directory -Name "GlobalSite" -Path "C:\"
New-Item -ItemType File -Name "index.html" -Path "C:\GlobalSite\"

#Install IIS Default WebSite and Default IIS Application Pool
Install-WindowsFeature -name Web-Server -IncludeManagementTools
Import-Module WebAdministration

Set-WebBinding -Name 'Default Web Site' -BindingInformation "*:80:" -PropertyName Port -Value 8080
#Remove-IISSite -Name "Default Web Site" -Confirm:$false

#Create new Application Pool
New-Item -Path IIS:\AppPools\GlobalAppPool

#Add a new website and set application pool of the site default application to a custom name
Start-IISCommitDelay
$TestSite = New-IISSite -Name GlobalSite -BindingInformation "*:80:" -PhysicalPath "C:\GlobalSite\" -Passthru
$TestSite.Applications["/"].ApplicationPoolName = "GlobalAppPool"
Stop-IISCommitDelay





#The command below will get the name of the computer
$ComputerName = "<h1>Computer name: $env:computername</h1>"

#The command below will get the Operating System information, convert the result to HTML code as table and store it to a variable
$OSinfo = Get-CimInstance -Class Win32_OperatingSystem | ConvertTo-Html -As List -Property Version,Caption,BuildNumber,Manufacturer -Fragment -PreContent "<h2>Operating System Information</h2>"

#The command below will get the Processor information, convert the result to HTML code as table and store it to a variable
$ProcessInfo = Get-CimInstance -ClassName Win32_Processor | ConvertTo-Html -As List -Property DeviceID,Name,Caption,MaxClockSpeed,SocketDesignation,Manufacturer -Fragment -PreContent "<h2>Processor Information</h2>"

#The command below will get the BIOS information, convert the result to HTML code as table and store it to a variable
$BiosInfo = Get-CimInstance -ClassName Win32_BIOS | ConvertTo-Html -As List -Property SMBIOSBIOSVersion,Manufacturer,Name,SerialNumber -Fragment -PreContent "<h2>BIOS Information</h2>"

#The command below will get the details of Disk, convert the result to HTML code as table and store it to a variable
$DiscInfo = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | ConvertTo-Html -As List -Property DeviceID,DriveType,ProviderName,VolumeName,Size,FreeSpace -Fragment -PreContent "<h2>Disk Information</h2>"

#The command below will get first 10 services information, convert the result to HTML code as table and store it to a variable
$ServicesInfo = Get-CimInstance -ClassName Win32_Service | Select-Object -First 10  |ConvertTo-Html -Property Name,DisplayName,State -Fragment -PreContent "<h2>Services Information</h2>"
  
#The command below will combine all the information gathered into a single HTML report
$Report = ConvertTo-HTML -Body "$ComputerName $OSinfo $ProcessInfo $BiosInfo $DiscInfo $ServicesInfo" -Title "Computer Information Report" -PostContent "<p>Creation Date: $(Get-Date)<p>"

#The command below will generate the report to an HTML file
$Report | Out-File 'C:\GlobalSite\index.html'

