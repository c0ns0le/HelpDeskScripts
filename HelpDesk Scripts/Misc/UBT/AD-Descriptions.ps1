####################################################
### Matthew Tietjens revised on 6/24/2015        ###
### Pulls the AD description for network users   ###
##################################3#################

#Gets the date for the file name. This will keep it from erroring out or overwriting if run more than once in a short period of time. 
$Date = Get-date -Format MM-dd-yyyy_hh-mm-ss

#Import AD module
Import-Module Activedirectory

#Pulls active AD users and the descriptions on each account. Puts the information in a table. 
Get-ADUser -Filter * -Properties Name,Description| Where-Object {$_.Enabled -eq 'True'} | 
Select @{N="User";E={$_.Name}},
@{N="Description";E={$_.Description}} | 

#Export information to CSV on local computer. 
Export-csv "C:\UFProject\DescriptionsTable-$Date.csv" -nti

#Copies informatino to the user form network folder.
Copy-Item "C:\UFProject\DescriptionsTable-$Date.csv" -Destination "\\ubt\groups\System Applications\User Form Project\Updated Information"