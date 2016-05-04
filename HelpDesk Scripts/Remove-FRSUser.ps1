#$getCred = Get-Credential -Message "Type in your password" -UserName mtietjens@forestridge.org
Connect-MsolService -Credential ($getCred)

do{
$getUser = Read-Host -Prompt "Type in login ID for the network user you would like to remove"

Remove-ADUser $getUser -Confirm

Remove-MsolUser -UserPrincipalName $getuser@forestridge.org
} while ((Read-Host -Prompt 'Type "yes" to delete another user') -ieq "Yes")