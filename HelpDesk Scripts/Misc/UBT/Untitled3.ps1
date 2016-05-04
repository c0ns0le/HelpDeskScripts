$Computers = Get-Content -Path 'C:\users\matthew.tietjens\Desktop\computer list.txt'

foreach ($Computer in $Computers) 
{
    if (Test-Connection -ComputerName $Computer -Quiet)
        {  
           New-Item -Path "\\$Computer\C$\Matt" -ItemType Directory
           Copy-Item -Path "C:\Testbatch\CD ROM\*" -Destination "\\$Computer\C$\Matt"

           #&psexec \\$Computer -s cmd.exe /c "C:\Matt\test.vbs"
           

        }
    else
        { 
            "Cannot pop CD tray."
        }
}
