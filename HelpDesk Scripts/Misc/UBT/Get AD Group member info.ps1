$ADGroups = Get-Content -Path 'C:\users\matthew.tietjens\desktop\AD Groups.txt'

$Content = @()

Foreach ($ADGroup in $ADGroups){

$Members = Get-ADGroupMember -Identity $ADGroup 

#$Contentlist = Foreach ($Member in $Members){ Select @{N="Name";E={$_.Name}},@{N="Phone";E={$_.telephoneNumber}},@{N="Description";E={$_.description}}

#Change the below to test adding members to array

$Content += $Members}
 
 -InputObject $Content -Path "C:\users\matthew.tietjens\desktop\List.xml" #}