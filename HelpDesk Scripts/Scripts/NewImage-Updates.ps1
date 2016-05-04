# Import Windows Update Module

Import-Module PSWindowsUpdate

# Create functions used in script

Function Get-WindowsUpdates {
Get-WUInstall -NotKBArticleID KB3012973 -IgnoreReboot -AcceptAll
}
Function Find-Fireworks {
Get-Process -Name Fireworks -ErrorAction SilentlyContinue
}
Function Start-Fireworks {
Start-Process "C:\Program Files (x86)\Adobe\Adobe Fireworks CS6\fireworks.exe" -Verb runas
Start-Sleep -s 15
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

# ------- 1st -------
# Find Windows updates

Get-WindowsUpdates

# ------- 2nd -------
# Open Adobe product
Do{
Start-Fireworks
try{Find-Fireworks}
catch{Start-Fireworks}
}While((Get-Process -Name Fireworks) -eq $null)

# ------- 3rd -------
# Clean up and reboot
Stop-Process -Name Fireworks -Force
Reboot-Computer