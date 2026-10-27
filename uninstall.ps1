<#
 Removes Nexus and legacy Bar (Windows PowerShell 5.1, run as administrator).
   uninstall.ps1           -> stops Nexus, puts Armoury Crate's Command Center back (Nexus.exe --restore-armoury),
                               removes the scheduled task "Nexus" and C:\Program Files\Nexus.
                               Keeps C:\ProgramData\Nexus and C:\ProgramData\Bar (settings and log).
   uninstall.ps1 -Purge    -> also removes C:\ProgramData\Nexus and C:\ProgramData\Bar.
   uninstall.ps1 -Force    -> removes Nexus even if Armoury Crate could not be confirmed as restored.
 Nothing is removed unless the restore is confirmed (Nexus.exe exit code 0 and Load.conf back to its 19 bytes).
#>
param([switch]$Purge, [switch]$Force)

$ErrorActionPreference = 'Stop'

function Fail($msg) { Write-Host "UNINSTALL FAILED: $msg" -ForegroundColor Red; exit 1 }

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) { Fail 'Run this script as administrator (right-click PowerShell, Run as administrator).' }
if ([string]::IsNullOrEmpty($env:ProgramW6432)) { Fail 'ProgramW6432 is not set; cannot find the 64-bit Program Files folder.' }

$Target       = Join-Path $env:ProgramW6432 'Nexus'
$LegacyTarget = Join-Path $env:ProgramW6432 'Game Bar'
$Data         = Join-Path $env:ProgramData 'Nexus'
$LegacyData   = Join-Path $env:ProgramData 'Bar'
$TaskName     = 'Nexus'
$LegacyTaskName = 'Game Bar'

$exe = Join-Path $Target 'Nexus.exe'
if (-not (Test-Path $exe)) { $exe = Join-Path $Target 'Bar.exe' }
if (-not (Test-Path $exe)) { $exe = Join-Path $LegacyTarget 'Bar.exe' }

$LoadConf = Join-Path $env:ProgramW6432 'ASUS\Armoury Crate SE Service\CommandCenter\Load.conf'

function Test-Restored {
    try { return ((Test-Path $LoadConf) -and ((Get-Item $LoadConf).Length -eq 19)) } catch { return $false }
}

# 1. Disable and remove scheduled tasks
foreach ($t in @($TaskName, $LegacyTaskName)) {
    $task = Get-ScheduledTask -TaskName $t -ErrorAction SilentlyContinue
    if ($task) {
        Disable-ScheduledTask -TaskName $t -ErrorAction SilentlyContinue | Out-Null
        Stop-ScheduledTask -TaskName $t -ErrorAction SilentlyContinue
    }
}

# 2. Stop running processes
$running = @(Get-Process -Name 'Nexus','Bar' -ErrorAction SilentlyContinue | Where-Object { 
    $_.Path -and (
        $_.Path.StartsWith($Target + '\', [StringComparison]::OrdinalIgnoreCase) -or 
        $_.Path.StartsWith($LegacyTarget + '\', [StringComparison]::OrdinalIgnoreCase)
    )
})
foreach ($p in $running) {
    Write-Host "Stopping $($p.ProcessName) (pid $($p.Id))"
    Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
}
foreach ($p in $running) { try { $p.WaitForExit(15000) | Out-Null } catch { } }

# Stop FFmpeg
$ffmpegRunning = @(Get-Process -Name 'ffmpeg' -ErrorAction SilentlyContinue | Where-Object {
    $_.Path -and (
        [IO.Path]::GetDirectoryName($_.Path).Equals($Target, [StringComparison]::OrdinalIgnoreCase) -or
        [IO.Path]::GetDirectoryName($_.Path).Equals($LegacyTarget, [StringComparison]::OrdinalIgnoreCase)
    )
})
foreach ($p in $ffmpegRunning) {
    Write-Host "Stopping ffmpeg (pid $($p.Id))"
    Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
}
foreach ($p in $ffmpegRunning) { try { $p.WaitForExit(15000) | Out-Null } catch { } }

# Stop ETW traces
try { & cmd.exe /c 'logman.exe stop NexusFrames -ets >nul 2>&1' } catch { }
try { & cmd.exe /c 'logman.exe stop GameBarFrames -ets >nul 2>&1' } catch { }

# 3. Restore Armoury Crate
$problem = $null
if (Test-Path $exe) {
    Write-Host "Putting Armoury Crate's Command Center back (this can take a minute)"
    & $exe --restore-armoury
    $rc = $LASTEXITCODE
    if ($rc -ne 0) { $problem = "Nexus restore failed (exit code $rc)" }
    elseif (-not (Test-Restored)) { $problem = "Load.conf is not back to its original state" }
}
elseif (-not (Test-Restored)) { $problem = "Nexus.exe was not found and Load.conf is not in its original state" }

if ($problem -and -not $Force) {
    Fail "$problem. Nothing was removed. Use -Force to remove anyway."
}

# 4. Remove tasks
foreach ($t in @($TaskName, $LegacyTaskName)) {
    if (Get-ScheduledTask -TaskName $t -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $t -Confirm:$false
    }
}

# 5. Remove install directories
if (Test-Path $Target) { Remove-Item -Path $Target -Recurse -Force }
if (Test-Path $LegacyTarget) { Remove-Item -Path $LegacyTarget -Recurse -Force }

# 6. Purge settings if requested
if ($Purge) {
    if (Test-Path $Data) { Remove-Item -Path $Data -Recurse -Force }
    if (Test-Path $LegacyData) { Remove-Item -Path $LegacyData -Recurse -Force }
    Write-Host "Settings and logs purged."
} else {
    Write-Host "Settings kept in $Data (and $LegacyData). Add -Purge to remove them too."
}

Write-Host "Nexus uninstalled cleanly." -ForegroundColor Green
exit 0
