cls

#Connect to O365
Connect-MsolService -Credential (Get-Credential)

do{

cls

#Get user account from interaction with script
$user = Read-Host "Type in user SamAccountName"
$object = Get-ADUser $user
$dname = $object.DistinguishedName

#Hide the user from the Outlook address lists
Set-ADUser -Identity $object -Add @{msExchHideFromAddressLists=$true} -Enabled $false

#Remove AD group membership
#Get-ADPrincipalGroupMembership -Identity $getID | % {Remove-ADPrincipalGroupMembership -Identity $getID -MemberOf $_}

#Disable O365 login
Get-MsolUser -UserPrincipalName "$user@forestridge.org" | Set-MsolUser -BlockCredential $True

#Prompt to move user to the Disabled Users OU
$answer = Read-Host "Do you really want to move $dname to the disabled users OU?"

#If yes, move to OU
If (($answer -eq "y") -or ($answer -eq "yes")){
Move-ADObject -Identity "$dname" -TargetPath "OU=Disabled Users,OU=FRSOU,DC=forestridge,DC=org"
}


#If no leave in current OU. Account is still disabled.
If (($answer -eq "n") -or ($answer -eq "no")){
"Account not moved"
}

#Prompt to ask if more users are being disabled. Will loop if yes. 
$answer2 = Read-Host "Do you want to do another user?"
} until (($answer2 -ieq "n") -or ($answer2 -ieq "no"))