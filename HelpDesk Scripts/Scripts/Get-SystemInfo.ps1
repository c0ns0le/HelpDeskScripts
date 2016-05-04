###########################################
###                                     ###
###   Log Computer Information to CSV   ###
###                                     ###
###########################################


# Cmdlets to gather the desired properties
$getComp = Get-WmiObject Win32_computersystem -ComputerName localhost
$getSN = Get-WmiObject Win32_Bios -ComputerName localhost
$getMAC = Get-NetAdapter -Physical
$getDate = Get-WmiObject win32_localtime


# Create new object to store the properties
$additems = New-Object PSObject 


# Add each property as a new object member
$additems | Add-Member -MemberType NoteProperty -Name "Name" -Value $getComp.Name
$additems | Add-Member -MemberType NoteProperty -Name "Model" -Value $getComp.Model
$additems | Add-Member -MemberType NoteProperty -Name "S/N" -Value ([string]$getSN.SerialNumber)
$additems | Add-Member -MemberType NoteProperty -Name "MAC" -Value ([string]$getMAC.MacAddress)
$additems | Add-Member -MemberType NoteProperty -Name "Date completed" -Value ([string]$getDate.Month + "/" + [string]$getDate.Day + "/" + [string]$getDate.Year)


# Map network location to local drive
New-PSDrive -Name H -PSProvider FileSystem -Root \\frs\software\inventory


# Export the information into a CSV
$additems | Export-Csv H:\2016_Manual_Inventory.csv -NoTypeInformation -Append


# Close network connection
Remove-PSDrive -Name H -Force