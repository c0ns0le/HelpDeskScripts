####################################################
### Matthew Tietjens revised on 6/24/2015        ###
### Pulls the group membership for network users ###
####################################################

#Gets the date for the file name. This will keep it from erroring out or overwriting if run more than once in a short period of time. 
$Date = Get-date -Format MM-dd-yyyy_hh-mm-ss

#Import AD module
Import-Module Activedirectory

#Pulls active AD users and their group membership. Adds information to a table. 
Get-ADUser -Filter * -Properties Name,memberof | Where-Object {$_.Enabled -eq 'True'} | % {
 $Name = $_.Name
 $_.memberof  | Get-ADGroup | Select @{N="User";E={$Name}},Name} | 

#Export information to CSV on local computer. 
Export-csv "C:\UFProject\ADGroups_$Date.csv" -nti

#Copies informatino to the user form network folder. 
Copy-Item "C:\UFProject\ADGroups_$Date.csv" -Destination "\\ubt\groups\System Applications\User Form Project\Updated Information"