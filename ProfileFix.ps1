<#------------------------------------------------------------------------------
    Jason McClary
    mcclarj@mail.amc.edu
    15 Mar 2016
    
    Description:
    Delete sqm file so new users can log on to a computer
    
    Arguments:
    If blank script runs against local computer
    Multiple computer names can be passed as a list separated by spaces:
        ProfileFix.ps1 computer1 computer2 anotherComputer
    A text file with a list of computer names can also be passed
        ProfileFix.ps1 comp.txt
    
    Tasks:
    - get computer name if needed
    - delete file
    
    Path to file:
    \\COMP_NAME\SYSTEM_DRIVE\Users\Default\AppData\Local\Microsoft\Windows\Temporary Internet Files\SQM
    
    File Name:  iesqmdata_setup0.sqm
    
------------------------------------------------------------------------------#>

# CONSTANTS
set-variable sqmPath -option Constant -value "$\Users\Default\AppData\Local\Microsoft\Windows\Temporary Internet Files\SQM\iesqmdata_setup*.sqm"

IF (!$args){
    $compNames = $env:computername # Get the local computer name
} ELSE {
    $passFile = Test-Path $args

    IF ($passFile -eq $True) {
        $compNames = get-content $args
    } ELSE {
        $compNames = $args
    }
}

FOREACH ($compName in $compNames) {
    
    IF(Test-Connection -count 1 -quiet $compName){
        $driveLetter = Get-WMIObject -class Win32_OperatingSystem -Computername $compName | select-object SystemDrive
        $currFilePath = "\\$compName\$($driveLetter.SystemDrive[0])$sqmPath"
        
        IF (Test-Path $currFilePath) {                                      # Check Path to delete
            Remove-Item -Force -Path $currFilePath
            "$compName - File found and deleted"
        } ELSE {
            "$compName - File Not Found"
        }

    } ELSE {
        "$compName - Unable to connect"
    }

}

