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

* exclude.txt           - files to exclude from backup
* include.txt           - files to include to backup
* exclude+.txt          - additional files to exclude from backup
* include+.txt          - additional files to include to backup
* includeNot4diskC.txt  - files to include to backup, but not for system disk C
* includeNot4diskC+.txt - additional files with some path to include to backup

By default, backup is configured for drive C and D:

```powershell
Start-Backup C $backupDir $exclude $include
Start-Backup D $backupDir $exclude ($include + $includeNot4diskC)
```

But you can change these drives, example:

```powershell
Start-Backup C $backupDir $exclude $include
Start-Backup D $backupDir $exclude ($include + $includeNot4diskC)
Start-Backup E $backupDir $exclude ($include + $includeNot4diskC)
Start-Backup X $backupDir $exclude ($include + $includeNot4diskC)
```

## Links

[7-Zip Extra files](https://www.7-zip.org/download.html)
