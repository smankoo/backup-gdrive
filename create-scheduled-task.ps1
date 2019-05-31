$curDir=(Get-Location).Path
$argument='-ExecutionPolicy ByPass -NoProfile -WindowStyle Hidden -command "& ''{0}\backup-gdrive.ps1''"' -f "$curDir"

$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $argument
$trigger = New-ScheduledTaskTrigger -Daily -At 12:21am -DaysInterval 1
$task = Register-ScheduledTask -TaskName "Backup Google Drive to OneDrive" -Trigger $trigger -Action $action -RunLevel Highest 
# $task.Triggers.Repetition.Duration = "P1D" # Repeat for a duration of one day
$task.Triggers.Repetition.Interval = "PT1H" # Repeat every hour, use PT30M for every 30 minutes
$task | Set-ScheduledTask

# Write-Output $argument