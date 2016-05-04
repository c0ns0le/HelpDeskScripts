do{

cls

$user = Read-Host "Please type in SAMAccountName of user you need to remove laptop reminders from"

Get-ADUser -Identity $user | Set-ADUser -ScriptPath clear

$answer = Read-Host "Would you like to add another user to the prompts?"

}while ($answer -ieq "y")