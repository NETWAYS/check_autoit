<#
.DESCRIPTION
    This plugin will execute an AutoIT script and
    return the runtime for the executed action. With
    this End2End monitoring will be alot easier integrated
    into Icinga environments    
.PARAMETER Executable
    This is the path to the AutoIT executable
.PARAMETER ConfigFile
    If your AutoIT script comes with a configuration
    file you can specify it with this parameter
.PARAMETER WarningValue
    The warning threshold for the script runtime
.PARAMETER CriticalValue
    The critical threshold for the script runtime
.PARAMETER Arguments
    Array of possible additional arguments required
    for the AutoIT script to run properly
.EXAMPLE
    C:\PS> 
    check_autoit.ps1 -Executable 'wikisearch.exe' `
                     -ConfigFile 'wikisearch.ini' `
                     -WarningValue 4 `
                     -CriticalValue 8 `
                     -Arguments 'nrpe', 'nsclient'
.NOTES
    Author:  Christian Stein
    Date:    October 25, 2016
    Company: NETWAYS GmbH
#>

# Define our input parameters at first
param(
        [string]$Executable,
        [string]$ConfigFile,
        [int]$WarningValue,
        [int]$CriticalValue,
        [array]$Arguments
)

# Ensure an executable has been defined in first place
if (-Not $Executable) {
    Write-Host 'Please specify a valid AutoIT executable file.' -ForegroundColor red;
    exit 3;
}

if (-Not (Test-Path $Executable)) {
    Write-Host 'Unable to locate ' $Executable -ForegroundColor red;
    exit 2;
}

<#
 Build our process info for executing the AutoIT script
 We require to wait until the script was executed
#>
$AutoIIProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
$AutoIIProcessInfo.FileName = $Executable
$AutoIIProcessInfo.RedirectStandardError = $true
$AutoIIProcessInfo.RedirectStandardOutput = $true
$AutoIIProcessInfo.UseShellExecute = $false
$AutoIIProcessInfo.Arguments = "$ConfigFile $Arguments"
$AutoIIProcess = New-Object System.Diagnostics.Process
$AutoIIProcess.StartInfo = $AutoIIProcessInfo
$AutoIIProcess.Start() | Out-Null
$AutoIIProcess.WaitForExit()

# Define variables to store our output data
$AutoITRunTime = $AutoIIProcess.ExitCode
$OutputMessage = '';
$ExitCode = 0;

# Now compare our result with the provided thresholds
if ($AutoITRunTime -eq 0) {
    Write-Host = 'Unknown! Returncode was ' + $AutoITRunTime + '';
    exit 3;
} elseif ($AutoITRunTime -le $WarningValue) {
    $OutputMessage = 'OK!';
    $ExitCode = 0;
} elseif ($AutoITRunTime -le $CriticalValue) {
    $OutputMessage = 'Warning!';
    $ExitCode = 1;
} elseif ($AutoITRunTime -gt $CriticalValue) {
    $OutputMessage = 'Critical!'
    $ExitCode = 2;
}

# Add some additional informations to our output message
$OutputMessage = $OutputMessage + ' AutoIt-Script was running in ' + $AutoITRunTime + ' sec. |Time=' + $AutoITRunTime + ';' + $WarningValue + ';' + $CriticalValue + '';

# Print the message to the console and exit the script
Write-Host $OutputMessage;
exit $ExitCode;