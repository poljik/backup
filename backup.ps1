param (
  [Parameter(Mandatory = $false)]
  [switch]$Install,
  [Parameter(Mandatory = $false)]
  [switch]$Remove
)

# detect OS bit
if ([System.Environment]::Is64BitOperatingSystem) {
  $global:bit_os2 = 64
} else {
  $global:bit_os2 = 32
}

if ($Install) {
  # copy files to windows dir
  Copy-Item -Path $PSScriptRoot\7zax$bit_os2\* -Destination $env:windir -Force
  Copy-Item -Path $PSScriptRoot\backup.ps1 -Destination $env:windir -Force
  Copy-Item -Path $PSScriptRoot\functions.psm1 -Destination $env:windir -Force
  Copy-Item -Path $PSScriptRoot\exclude*.txt -Destination $env:windir -Force
  Copy-Item -Path $PSScriptRoot\include*.txt -Destination $env:windir -Force

  # add windows task for backup
  $Action = New-ScheduledTaskAction -Execute powershell.exe -WorkingDirectory %windir% -Argument "-noprofile -executionpolicy bypass -file %windir%\backup.ps1"
  $Trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 1 -At 10am
  $Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -ExecutionTimeLimit (New-TimeSpan -Hours 2) -StartWhenAvailable
  $Params = @{
    "TaskName" = "backup"
    "Action"   = $Action
    "Trigger"  = $Trigger
    "Settings" = $Settings
  }
  Register-ScheduledTask @Params -User "NT AUTHORITY\SYSTEM" -RunLevel Highest -Force > $Null
  exit
} elseif ($Remove) {
  Remove-Item $env:windir\7z*.* -confirm:$false
  Remove-Item $env:windir\backup.ps1 -confirm:$false
  Remove-Item $env:windir\functions.psm1 -confirm:$false
  Remove-Item $env:windir\exclude*.txt -confirm:$false
  Remove-Item $env:windir\include*.txt -confirm:$false
  Unregister-ScheduledTask -TaskName backup -Confirm:$false -ErrorAction SilentlyContinue
  exit
}

Import-Module -Name .\functions.psm1 -PassThru -Force > $Null

$backupDir       = "D:\distr\backup\"
$numberBackup    = 14 # 7 for C disk, 7 - D
$Global:infoMode = 0
$Global:7zexe    = "7za.exe"
$Global:7zcmd    = "a -t7z -ssw -spf2 -mmt2 -mx3 -r0"

$exclude           = Get-Content -Path .\exclude.txt -ErrorAction SilentlyContinue
$include           = Get-Content -Path .\include.txt -ErrorAction SilentlyContinue
$includeNot4diskC  = Get-Content -Path .\includeNot4diskC.txt -ErrorAction SilentlyContinue

$includeNot4diskC += Get-Content -Path .\includeNot4diskC+.txt -ErrorAction SilentlyContinue
$exclude          += Get-Content -Path .\exclude+.txt -ErrorAction SilentlyContinue
$include          += Get-Content -Path .\include+.txt -ErrorAction SilentlyContinue

Start-Backup C $backupDir $exclude $include
Start-Backup D $backupDir $exclude ($include + $includeNot4diskC)
Clear-Folder $backupDir $numberBackup