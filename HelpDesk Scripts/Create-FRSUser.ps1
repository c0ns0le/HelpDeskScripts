<#The prerequisites below need to be installed before running this script.

Microsoft Online Services Sign-In Assistant
http://www.microsoft.com/en-us/download/details.aspx?id=41950

Azure Active Directory Module for Windows Powershell
http://go.microsoft.com/fwlink/p/?linkid=236297                #>

 
 ########################## 
###                      ###
###  This script is for  ###
###  creating new FRS    ###
###  network accounts    ###
###                      ###
###  written by          ###
###  - Matthew Tietjens  ###
###                      ###
 ########################## 


 ################################################################################################ 
###               Please type your username in here ------------------------.                    #
##                                                                          |                   ##
#                                                                           V                  ###
$getCred = Get-Credential -Message "Please enter password" -UserName mtietjens@forestridge.org 
 ################################################################################################ 


Import-Module activedirectory
Import-Module MSOnline


 #####################################################################
###                                                                 ###
### Functions are declared here for easy readability in the script. ###
###                                                                 ###
 #####################################################################   


# Functions to gather info

function Account-Type{

do {
$global:getLicense = Read-Host -Prompt 'Please enter account type - student, faculty, staff, or other'

if ($getLicense -notlike "student" -and $getLicense -notlike "faculty" -and $getLicense -notlike "staff" -and $getLicense -notlike "other")
{
""
"Account type must be student, faculty, staff, or other"
""
$repeat1 = "Yes"}

else{$repeat1 = "No"} 

}while($repeat1 -ieq "Yes")

}

function First-Name{
$global:getFirst = Read-Host -Prompt "Please type in the user's first name"
}

function Last-Name{
$global:getLast    = Read-Host -Prompt "Please type in the user's last name"
}

function Login-ID{
$global:getID = Read-Host -Prompt "Please type in the user's login credential"
}

function Student-Info{

#Set variables
    $global:LicenseType = `
    "frssh:STANDARDWOFFPACK_IW_STUDENT"

$global:getClass = Read-Host -Prompt "Graduation year (in YYYY form)?"
""
""
"Information entered"
"---------------------------------------"
"Name     : $getLast, $getFirst"                         
"Login    : $getID"
"Account  : $getLicense"
"Class of : $getClass"
"---------------------------------------"
""
""
}

function NonStudent-Info{
#Set variables
    $global:LicenseType = "frssh:STANDARDWOFFPACK_IW_FACULTY"
""
""
"Information entered"
"---------------------------------------"
"Name    : $getLast, $getFirst"                         
"Login   : $getID"
"Account : $getLicense"
"---------------------------------------"
""
""
}

# Functions to create and configure

function Create-ADUser{

$global:Password = "Password1"
$global:encPass = ($Password | ConvertTo-SecureString -AsPlainText -Force)
$global:email = "$getID@forestridge.org"

    New-ADUser `
        -DisplayName "$getLast, $getFirst" `
        -Path "$getOU" `
        -GivenName $getFirst `
        -Surname $getLast `
        -Name "$getLast, $getFirst"`
        -SamAccountName $getID `
        -AccountPassword $encPass `
        -PasswordNeverExpires $true `
        -EmailAddress $email `
        -UserPrincipalName $email `
        -OtherAttributes @{Proxyaddresses="SMTP:$email"} `
        -PassThru ` | Enable-ADAccount   
}

function Student-ADGroups{
$global:ADGroup1 = Get-ADGroup -Identity STUTO365
$global:ADGroup2 = Get-ADGroup -Identity "Class of $getClass"

Add-ADGroupMember -Identity $ADGroup1 -Members $getID
Add-ADGroupMember -Identity $ADGroup2 -Members $getID
}

function Adult-ADGroups{
$global:ADGroup1 = Get-ADGroup -Identity ADULTSTO365
$global:ADGroup2 = Get-ADGroup -Identity Adults

Add-ADGroupMember -Identity $ADGroup1 -Members $getID
Add-ADGroupMember -Identity $ADGroup2 -Members $getID
}

function Sync-O365User{

### Run AD Sync task from FRS-AADSYNC remotely

    Invoke-Command {schtasks /run /tn "Azure AD Sync Scheduler"}`
        -ComputerName "FRS-AADSYNC"`
        -Credential ($getCred) `
        -ErrorAction Stop

### Waiting...

Progress-Bar

### Connect to O365 and give time to sync

    Connect-MsolService `
        -Credential $getCred


########### Provision the Office 365 license for student ###########

    Set-MsolUser `
        -UserPrincipalName $email `
        -UsageLocation "US"

    Set-MsolUserLicense `
        -UserPrincipalName $email `
        -AddLicenses "$LicenseType"
}
function Progress-Bar($sleep = 45){

for ($i=$sleep; $i -gt 1; $i--) {

    Write-Progress `
        -Activity "Giving AD and O365 time to sync" `
        -Status "Syncing...." `
        -PercentComplete $i `
        
    Start-Sleep 1
}
}


 #######################
###                   ###
### The actual script ###
###                   ###
 #######################


do{

# Start loop

do{ 

# Get all of the information necessary to create the new user 

Account-Type
""
First-Name
""
Last-Name
""
Login-ID
""
If($getLicense -ieq "student"){Student-Info}
Else{NonStudent-Info}
""
$getInfo = Read-Host "Are these fields correct? (Y/N)"
""
if($getInfo -ine "y" -and $getInfo -ine "n"){"$getInfo is not a recognizable command."}
} until($getInfo -ieq "y")


 ########################### 
##     Student accounts    ##
 ########################### 
if($getLicense -ieq "student"){

#.........................#
#  Run AD user function   #
#'''''''''''''''''''''''''#
  # Set variables
    $global:getOU = `
    "OU=Class of $getClass,OU=Students,OU=FRSOU,DC=forestridge,DC=org"

  # Call function
  try{Create-ADUser}
     
    catch [system.exception]{
    $ADError = Write-Host "Error occured creating the user. Terminating script."
    Start-Sleep -s 10
    Break
    }

  # Add AD Groups
  try{Student-ADGroups}
     
    catch [system.exception]{
    $ADError = Write-Host "Error occured creating the user. Terminating script."
    Start-Sleep -s 10
    Break
    }

  # Message
    ""
    "User has been created in Active Directory"
    ""


#.........................#
#    Run O365 function    #
#'''''''''''''''''''''''''#
  
  # Call function
  try{
    Sync-O365USER -License $LicenseType
    }

    catch [system.exception]{
    $ADError = Write-Host "Error occured in configuring MSOL. AD sync may not have finished yet. Please add the license manually, or delete AD user and try again. Terminating script."
    Start-Sleep -s 10
    Break
    }

  # Message
    ""
    "-------------------------------------------------------------------------------"
    ""
    "Active Directory user $getFirst $getLast has been created."
    ""
    "User is located in $getOU."
    ""
    "Added to groups:"
    "$ADGroup1"
    "$ADGroup2"
    ""
    "User has been assigned the O365 license $LicenseType."
    ""
    "-------------------------------------------------------------------------------"
    ""
    }


 ########################### 
##  Staff/Faculty accounts ##
 ########################### 
if(($getLicense -ieq "staff") -or ($getLicense -ieq "faculty")){

#.........................#
#  Run AD user function   #
#'''''''''''''''''''''''''#

if($getLicense -ieq "staff"){
  # Set variables
    $global:getOU = `
    "OU=Staff & Admin,OU=FRSOU,DC=forestridge,DC=org"
}
Else{
    $global:getOU = `
    "OU=Faculty,OU=FRSOU,DC=forestridge,DC=org"
}

  # Call function
  try{Create-ADUSER}

    catch [system.exception]{
    $ADError = Write-Host "Error occured creating the user. Terminating script."
    Start-Sleep -s 10
    Break
    }

if($getLicense -ieq "staff"){
  # Add AD Groups
  try{Adult-ADGroups}
     
    catch [system.exception]{
    $ADError = Write-Host "Error occured creating the user. Terminating script."
    Start-Sleep -s 10
    Break
    }
}

if($getLicense -ieq "faculty"){
  # Add AD Groups
  try{Adult-ADGroups}
     
    catch [system.exception]{
    $ADError = Write-Host "Error occured creating the user. Terminating script."
    Start-Sleep -s 10
    Break
    }
}

  # Message
    ""
    "User has been created in Active Directory"
    ""


#.........................#
#    Run O365 function    #
#'''''''''''''''''''''''''#

  # Call function
  try{
    Sync-O365USER
    }

    catch [system.exception]{
    $ADError = Write-Host "Error occured in configuring MSOL. AD sync may not have passed through yet. Please add the license manually, or delete AD user and try again. Terminating script."
    Start-Sleep -s 10
    Break
    }

  # Message
    ""
    "-------------------------------------------------------------------------------"
    ""
    "Active Directory user $getFirst $getLast has been created."
    ""
    "User is located in $getOU."
    ""
    "Added to groups:"
    "$ADGroup1"
    "$ADGroup2"
    ""
    "User has been assigned the O365 license $LicenseType."
    ""
    "-------------------------------------------------------------------------------"
    ""
    }


 ########################### 
##      Other accounts     ##
 ########################### 
if($getLicense -ieq "other"){

#.........................#
#  Run AD user function   #
#'''''''''''''''''''''''''#

  # Set variables
    $global:getOU = "OU=Other Users,OU=FRSOU,DC=forestridge,DC=org"

  # Call function
  try{Create-ADUser
     }

    catch [system.exception]{
    $ADError = Write-Host "Error occured creating the user. Terminating script."
    Start-Sleep -s 10
    Break
    }

   # Message
    ""
    "User has been created in Active Directory"
    ""

#.........................#
#    Check email need     #
#'''''''''''''''''''''''''#

  # Prompt user

    $answerOther = Read-Host "Does this user need O365 access? (Y/N)"

    if($answerOther -ine "y" -and $getInfo -ine "n"){"$getInfo is not an accepted command."}

If($answerOther -ieq "y"){

 # Add AD Groups
  try{Adult-ADGroups}
     
    catch [system.exception]{
    $ADError = Write-Host "Error occured creating the user. Terminating script."
    Start-Sleep -s 10
    Break
    }

#.........................#
#    Run O365 function    #
#'''''''''''''''''''''''''#

  # Call function

  try{
    Sync-O365USER
    }

    catch [system.exception]{
    $ADError = Write-Host "Error occured in configuring MSOL. AD sync may not have passed through yet. Please add the license manually, or delete AD user and try again. Terminating script."
    Start-Sleep -s 10
    Break
    }

  # Message
    ""
    "-------------------------------------------------------------------------------"
    ""
    "Active Directory user $getFirst $getLast has been created."
    ""
    "User is located in $getOU."
    ""
    "Added to groups:"
    "$ADGroup1"
    "$ADGroup2"
    ""
    "User has been assigned the O365 license $LicenseType."
    ""
    "-------------------------------------------------------------------------------"
    ""
}

If($answerOther -ieq "n"){

    $global:ADGroup2 = Add-ADGroupMember -Identity Adults -Members $getID

  # Message
    ""
    "-------------------------------------------------------------------------------"
    ""
    "Active Directory user $getFirst $getLast has been created."
    ""
    "User is located in $getOU."
    ""
    "Added to groups:"
    "$ADGroup2"
    ""
    "No Office 365 license has been assigned."
    ""
    "-------------------------------------------------------------------------------"
    ""
    }
}

# Loop script

$loopy = Read-Host "Would you like to create another user? (Y/N)"
""
} while($loopy -ieq "y")