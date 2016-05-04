 
$domain = "forestridge.org" 
 
################## 
#--------Main 
################## 
 
import-module activedirectory 
do{
$search = Read-Host "Type in the name of AD user or AD computer ('exit' to quit)" 
cls
""
"------------"
"Users"
"------------"

$users = Get-ADUser -Filter "name -like '*$search*'" -SearchBase "OU=FRSOU,DC=forestridge,DC=org" -Properties name,samaccountname,userprincipalname | Select name,samaccountname,userprincipalname
""

$myForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest() 
$domaincontrollers = $myforest.Sites | % { $_.Servers } | Select Name 
$RealUserLastLogon = $null 
$RealCompLastLogon = $null
$UserusedDC = $null 
$CompusedDC = $null
$domainsuffix = "*."+$domain 

foreach ($user in $users)
{$UserusedDC = $null

    foreach ($DomainController in $DomainControllers)  
    { 

        if ($DomainController.Name -like $domainsuffix ) 
        { 

            $UserLastlogon = Get-ADUser -Identity $user.samaccountname -Properties LastLogon,description -Server $DomainController.Name 

            if ($RealUserLastLogon -le [DateTime]::FromFileTime($UserLastlogon.LastLogon)) 
            { 
                $RealUserLastLogon = [DateTime]::FromFileTime($UserLastlogon.LastLogon) 
                $UserusedDC =  $DomainController.Name 
            } 

        } 

    } 

    $UserLastLogon | Format-List  @{N="Name"; E={$_.name}}, @{N="UPN"; E={$_.userprincipalname}}, @{N="Last Logon Time"; E={$RealUserLastLogon}}, @{N="OU"; E={$_.distinguishedName}}, @{N="Created"; E={$_.whenCreated}}, @{N="Description"; E={$_.description}}

}

""
"------------"
"Computers"
"------------"
$computers = Get-ADComputer -Filter "name -like '*$search*'" -Properties name,operatingSystem,lastLogon,samAccountName | Select name,operatingSystem,lastLogon,samAccountName


foreach ($computer in $computers)
{$CompusedDC = $null

    foreach ($DomainController in $DomainControllers)  
    { 

        if ($DomainController.Name -like $domainsuffix ) 
        { 

            $CompLastlogon = Get-ADComputer -Identity $computer.samaccountname -Properties LastLogon,operatingsystem -Server $DomainController.Name 

            if ($RealCompLastLogon -le [DateTime]::FromFileTime($CompLastlogon.LastLogon)) 
            { 
                $RealCompLastLogon = [DateTime]::FromFileTime($CompLastlogon.LastLogon) 
                $CompusedDC =  $DomainController.Name 
            } 

        } 

    } 
    $CompLastlogon | Format-List  @{N="Laptop/Computer"; E={$_.name}}, @{N="OS Version"; E={$_.operatingSystem}}, @{N="Last Logon Time"; E={$RealCompLastLogon}}, @{N="OU"; E={$_.distinguishedName}}, @{N="Created"; E={$_.whenCreated}}
}

} until ($search -ieq "exit")