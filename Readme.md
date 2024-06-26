# Backup utility

## Install script

```powershell
./backup.ps1 -Install
```

## Remove script

```powershell
./backup.ps1 -Remove
```

## Description

* exclude.txt    - files to exclude from backup
* include.txt    - files to include to backup
* exclude+.txt   - additional files to exclude from backup
* include+.txt   - additional files to include to backup
* includeCD.txt  - files with some path to include to backup
* includeCD+.txt - additional files with some path to include to backup

By default, backup is configured for drive C and D:

```powershell
Start-Backup C $backupDir $exclude $includeCD
Start-Backup D $backupDir $exclude ($include + $includeCD)
```

But you can change these drives, example:

```powershell
Start-Backup C $backupDir $exclude $includeCD
Start-Backup D $backupDir $exclude ($include + $includeCD)
Start-Backup E $backupDir $exclude ($include + $includeCD)
Start-Backup X $backupDir $exclude ($include + $includeCD)
```

## Links

[7-Zip Extra files](https://www.7-zip.org/download.html)
