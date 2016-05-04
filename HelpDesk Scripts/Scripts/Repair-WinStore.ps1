
# Create path variable for current Microsoft.WindowsStore directory
$path = Get-Appxpackage -Allusers -Name Microsoft.WindowsStore

# Run one-liner to repair
Add-AppxPackage -register "C:\Program Files\WindowsApps\$path\AppxManifest.xml" -DisableDevelopmentMode