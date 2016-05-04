$Computers = Get-Content 'C:\users\matthew.tietjens\desktop\New Text Document.txt'

$ADlist = @()

Foreach ($Computer in $Computers)
{
$Target = Get-ADComputer -Filter "CN -like '*$Computer*'" -Properties @{N="Name";E={$_.Name}}
$ADlist += $Target
}

Out-file -InputObject $ADlist 'C:\users\matthew.tietjens\Desktop\Computer list1.txt'