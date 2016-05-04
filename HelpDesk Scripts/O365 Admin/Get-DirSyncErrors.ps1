Get-MsolUser -MaxResults 1000 | where {$_.LastDirSyncTime -eq $Null} | Select DisplayName,UserPrincipalName,UsageLocation,License,Errors | epcsv C:/InCloudList.csv

Start-Process C:/InCloudList.csv