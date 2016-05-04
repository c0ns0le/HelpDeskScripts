Get-ADComputer -Filter * -Properties name,operatingSystem,lastLogon,samAccountName,DistinguishedName,IPV4Address | `
Select name,operatingSystem,lastLogon,samAccountName,DistinguishedName,IPV4Address | `
Sort -Property name | `
Sort -Property operatingSystem -Descending| `
Select  @{N="Laptop/Computer"; E={$_.name}}, @{N="OS Version"; E={$_.operatingSystem}}, @{N="Last Logon Time"; E={[DateTime]::FromFileTime($_.LastLogon)}}, @{N="IP Address"; E={$_.IPV4Address}}, @{N="OU"; E={($_.DistinguishedName -split “,”, 2)[1]}} | `
Export-Csv C:\computerlist.csv

Start-Process C:\computerlist.csv
