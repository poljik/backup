function Start-Backup ([Array]$disks, [string]$dir, [Array]$exclude, [Array]$include, [string]$addName) {
  # create backup folder, if not
  New-Item -Path $dir -ItemType Directory -ErrorAction SilentlyContinue

  $exclude | ForEach-Object {$exc += " `"-xr!$_`""}
  $include | ForEach-Object {$inc += " `"-ir!$_`""}
  
  $path  = $dir + $env:COMPUTERNAME.ToLower() + "_"
  if ($addName) {
    $path += $addName
  } else {
    $disks | ForEach-Object {$path += $_}
  }
  $path += "_" + (Get-Date -UFormat "%Y-%m-%d_%H-%M")
  
  foreach ($disk in $disks) {
    $disk += ":\"
    if ($infoMode) {
      Write-Host "-----", $disk, "-----"
      if ($include) {
        Write-Host "-Include", $include -ForegroundColor Yellow
      }
      if ($exclude) {
        Write-Host "-Exclude", $exclude -ForegroundColor Red
      }
    }
    Push-Location
    Set-Location -Path $disk
    Invoke-Expression "$7zexe $7zcmd $inc $exc `"$path`"" -OutVariable output | Write-Verbose
    Start-Process -Filepath $7zexe -ArgumentList "d", `"$path.7z`", "* -r -x!\*.*" -WindowStyle Hidden -Wait
    Pop-Location
    if ($infoMode -and ([string]$output).Contains("Everything is Ok")) {
      Write-Host "Adding to archive `"$path`" complete" -ForegroundColor Green
    }
  }
}
# clear folder, keep last N files
function Clear-Folder ([string]$dir, [int]$number) {
  $files = Get-ChildItem $dir | Sort-Object -Property CreationTime
  for ($i = 0; $i -lt ($files.Count - $number); $i++) {
    Remove-Item $dir$($files[$i]) -Force -Recurse
    if ($infoMode) {
      Write-Host "Old archive `"$dir$($files[$i])`" removed" -ForegroundColor Green
    }
  }
}

Export-ModuleMember -Function *