function Get-SMTP{
$global:user = Read-Host "Type in the user's login name"

Get-ADUser -Identity $user -Properties UserPrincipalName,ProxyAddresses | Select UserPrincipalName,ProxyAddresses

}

function Change-SMTP{$answer = Read-Host "Do you want to change proxy address?"

If (($answer -eq "y") -or ($answer -eq "yes")) {

Get-ADUser -Identity $user -Properties ProxyAddresses | Set-ADUser -Add @{ProxyAddresses="SMTP:$user@forestridge.org"} 

Get-ADUser -Identity $user -Properties UserPrincipalName,ProxyAddresses | Select UserPrincipalName,ProxyAddresses

}

Else{"Nothing has been changed"}
}

Get-SMTP
Change-SMTP
