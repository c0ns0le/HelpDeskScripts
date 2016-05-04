$getcred = Get-Credential
$getname = Read-Host "What do you want the PC name to be?"

function Join-Domain {
Add-Computer -DomainName forestridge.org `
             -Credential $getcred `
             -NewName $getname `
             -OUPath "OU=Computers,OU=FRSOU,DC=forestridge,DC=org" `
             -ErrorAction Stop
}
function New-ComputerName{

Try{Rename-Computer -NewName $getname `
                -DomainCredential $getcred `
                -ErrorAction Stop
                
                $text = $true}
Catch{"The PC could not be renamed to $getname. Check to see if this name exists in AD before running again."
                $text =$false}
Finally{
        if($text = $true){"PC has been successfully renamed to $getname."}
        else{" "}
}
}
function Loop-Switch{

    Do{

        switch($answer = Read-Host "PC is already on the domain. Would you like to rename the PC? (Y/N)"){
            default{Loop-Switch}
            Y {New-ComputerName}
            N {exit}
            exit {exit}
        }

    }while(($answer -inotmatch "y") -and ($answer -inotmatch "n"))

}
function Reboot-Computer{

    Do{

        switch($Reboot = Read-Host "Restart the computer? (Y/N)"){
            default{Reboot-Computer}
            Y {Restart-Computer localhost -Force}
            N {exit}
            exit {exit}
        }
    }while (($Reboot -inotmatch "y") -and ($Reboot -inotmatch "n"))

}


####################
#####  Script  #####
####################

try{Join-Domain}
catch [System.InvalidOperationException]{Loop-Switch}

Reboot-Computer