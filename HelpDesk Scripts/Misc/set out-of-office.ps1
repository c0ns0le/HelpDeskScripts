start powershell.exe 'C:\users\mtietjens\Desktop\connect-msexchange.ps1' -PassThru

$start = Read-Host "What day will your out-of-office begin?"
$end = Read-Host "What day will your out-of-office end?"

Set-MailboxAutoReplyConfiguration -Identity mtietjens -InternalMessage "I will be out of office from $start through $end." -StartTime (Get-Date) -AutoReplyState Enabled