$gDriveLocation = $env:USERPROFILE + "\Google Drive"
$oneDriveLocation = $env:OneDrive
$logDir= $env:TEMP + "\backup-gdrive"
$ts = Get-Date -Format yyy-MM-dd
$backupLocation = $oneDriveLocation + "\Backup\Google Drive"
$targetDir = $backupLocation + "\" + $ts
$dateRegex = "20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]"

$maxBackups = 1


if (Test-Path "$gDriveLocation" -PathType Container){
    if (Test-Path "$oneDriveLocation" -PathType Container){
        Write-Output "Both gDriveLocation: $gDriveLocation and oneDriveLocation: $oneDriveLocation exist. Will call RoboCopy..."

        # Create directories for target and log if they do not already exist
        New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
        New-Item -ItemType Directory -Force -Path $logDir | Out-Null

        # Measure source folder size before copy starts
        $gDriveSize = (Get-ChildItem "$gDriveLocation" -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum
    
        Write-Output "Copying $gDriveLocation into $targetDir..."
        robocopy "$gDriveLocation" "$targetDir" /LOG+:$logDir\robolog.txt /MIR /copyall /zb /w:1 /r:2 /xo
        Write-Output "ROBOCOPY exited with Exit Code $LastExitCode"
        # Measure destination folder size after copy finishes
        $targetDirSize = (Get-ChildItem "$targetDir" -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum

        if ($LastExitCode -eq 1 -or $LastExitCode -eq 0){
            Write-Output "Robocopy operation was successful."

            # Check if target directory size is at least as large as the source directory
            if ( $targetDirSize -ge $gDriveSize ){
                Write-Output "Source dir size was: $gDriveSize, which is greater than or equal to the Backup dir size : $targetDirSize"
                Write-Output "Obsolete backups can now be deleted..."

                $obsoleteBackupDirs = Get-ChildItem -Path "$backupLocation" -Directory | Where-Object {$_.Name -match "$dateRegex"} | Sort-Object Name -Descending | Select-Object -Skip $maxBackups

                Write-Output "Maximum number of Backups to keep is $maxBackups."

                if($obsoleteBackupDirs.Length -eq 0) {
                    Write-Output "No obsolete backups found"
                } else {
                    foreach ($obsoleteBackupDir in $obsoleteBackupDirs) {
                        Write-Output "$backupLocation\$obsoleteBackupDir is obsolete and will be deleted"
                        Remove-Item -Path "$backupLocation\$obsoleteBackupDir" -Recurse -Force
                    }
                }
            }
        }

    } else {
        Write-Output "oneDriveLocation: $oneDriveLocation does not exist."
    }
} else {
    Write-Output "gDriveLocation: $gDriveLocation does not exist."
}