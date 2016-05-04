#Prompt for a computer to connect to 
$computer = $env:COMPUTERNAME

#Execute Script
Do {     

#Gather all of the user profiles on computer 
Try { 
    [array]$users = Get-WmiObject -ComputerName $computer Win32_UserProfile -filter "LocalPath Like 'C:\\Users\\%'" -ea stop 
    } 
Catch { 
    Write-Warning "$($error[0]) "
    Break
    }     

#Cache the number of users 
$num_users = $users.count 
  
Write-Host -ForegroundColor Green "User profiles on $($computer):"
  
    #Begin iterating through all of the accounts to display 
    For ($i=0;$i -lt $num_users; $i++) { 
        Write-Host -ForegroundColor Green "$($i): $(($users[$i].localpath).replace('C:\Users\',''))"
        } 
    Write-Host -ForegroundColor Green "q: Quit"

    #Prompt for user to select a profile to remove from computer 
    Do {     
        $account = Read-Host "Type number to choose profile for copying, or 'q' to quit"

        #Find out if user selected to quit, otherwise answer is an integer 
        If ($account -NotLike "q*") { 
            $account = $account -as [int]
            } 
        }         

    #Ensure that the selection is a number and within the valid range 
    Until (($account -lt $num_users -AND $account -match "\d") -OR $account -Like "q*") 
    If ($account -Like "q*") { 
        Break
        } 
    ""
    #Get the location to copy user profile files
    $location = Read-Host "Type the full path of where you would like to copy this profile (will overwrite any files if C:\Users\%userprofile% is chosen)"
    Write-Host -ForegroundColor Yellow "Copying profile: $(($users[$account].localpath).replace('C:\Users\',''))"
    ""
    #Copy over the profile items, excluding NTUSER
    Copy-Item "$(($users[$account].localpath))" $location -Exclude NTUSER.dat,NTUser.dat.log -Recurse -Force -ErrorAction SilentlyContinue
    ""
    Write-Host -ForegroundColor Green "Profile:  $(($users[$account].localpath).replace('C:\Users\','')) has been copied"
    ""
    #Configure yes choice 
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Copy another profile."
    ""
    #Configure no choice 
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Quit"
  
    #Determine Values for Choice 
    $choice = [System.Management.Automation.Host.ChoiceDescription[]] @($yes,$no) 
  
    #Determine Default Selection 
    [int]$default = 0 
  
    #Present choice option to user 
    $userchoice = $host.ui.PromptforChoice("","Copy Another Profile?",$choice,$default) 
    } 
#If user selects No, then quit the script     
Until ($userchoice -eq 1)