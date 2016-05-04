do{

cls

$user = Read-Host "Please type in SAMAccountName of user you would like to receive reminders about returning their laptop"

Get-ADUser -Identity $user | Set-ADUser -ScriptPath "\\frs\software\tech staff\matt\loanerreminders\setup_reminder.bat"

"The user will be forced to reboot at their chosen interval, and will begin receiving prompts after the reboot."

$answer = Read-Host "Would you like to add another user to the prompts?"

}while ($answer -ieq "y")