# Backup-gDrive
Backs up your Google Drive contents to OneDrive. 
- Script `backup-gdrive.ps1` syncs `<Google Drive>` contents to `<Your OneDrive Folder>\Backup\Google Drive\\<Date>` using ROBOCOPY
- Script `create-scheduled-task.ps1` creates a scheduled task to run this script once every hour

By default 3 most recent backups are kept, the rest are deleted.
You can change this setting at the top of `backup-gdrive.ps1`

# Installation

## Set up Automatic Scheduled Backups
  - Download or Clone this repository to your computer
  - Open Powershell as Administrator and Run `.\create-scheduled-task.ps1`

## Run a One-time Backup
  - Open Powershell as Administrator and Run `.\backup-gdrive.ps1`
