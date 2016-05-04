
do{
$user = Read-Host "Type in the user's domain credential"
""
""
Get-MSOLUser -UserPrincipalName "$user@forestridge.org" | select displayname,lastname,firstname,userprincipalname,lastdirsynctime,islicensed,@{N="License Type";E={$_.Licenses.AccountSkuId}},validationStatus,LiveID,AlternateEmailAddresses,BlockCredential
""
""
Get-ADUser -Identity $user -Properties canonicalname,displayname,distinguishedName,givenName,surname,name,proxyAddresses,sAMAccountName,mail,userPrincipalName,Enabled | Select canonical,display,distinguishedName,givenName,surname,name,proxyAddresses,sAMAccountName,mail,userPrincipalName,Enabled
""
""} until ($user -eq "quit")