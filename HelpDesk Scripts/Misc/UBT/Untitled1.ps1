$Time = Get-date -Format MM-dd-yyyy-hh-mm-ss

Get-ADUser -Filter * -Properties Name,physicalDeliveryOfficeName| Where-Object {$_.Enabled -eq 'True'} | 
Select @{N="Name";E={$_.Name}},
@{N="Office";E={$_.physicalDeliveryOfficeName}} | 
Export-csv "C:\UFProject\Test_$Time.csv" -nti