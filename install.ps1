<#
 Installs Nexus for this Windows user (Windows PowerShell 5.1, run as administrator).
   install.ps1             -> copies bin\ to C:\Program Files\Nexus, registers the scheduled task "Nexus"
                               (runs at logon of the account running this script, highest privileges), then starts it.
 Safe to run again: it stops the running Nexus (and legacy Bar), copies the new files and registers the task again.
 Build first: build.ps1 (creates bin\Nexus.exe).
#>
$ErrorActionPreference = 'Stop'

function Fail($msg) { Write-Host "INSTALL FAILED: $msg" -ForegroundColor Red; exit 1 }

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) { Fail 'Run this script as administrator (right-click PowerShell, Run as administrator).' }
if ([string]::IsNullOrEmpty($env:ProgramW6432)) { Fail 'ProgramW6432 is not set; cannot find the 64-bit Program Files folder.' }

$Root    = Split-Path -Parent $MyInvocation.MyCommand.Path
$Bin     = Join-Path $Root 'bin'
$Target  = Join-Path $env:ProgramW6432 'Nexus'
$LegacyTarget = Join-Path $env:ProgramW6432 'Game Bar'
$TaskName = 'Nexus'
$LegacyTaskName = 'Game Bar'
$User    = [Security.Principal.WindowsIdentity]::GetCurrent().Name
if (-not (Test-Path $Bin)) { $Bin = $Root }
if (-not (Test-Path (Join-Path $Bin 'Nexus.exe'))) { 
    if (Test-Path (Join-Path $Root 'Nexus.exe')) { $Bin = $Root }
    elseif (Test-Path (Join-Path $Bin 'Bar.exe')) { Copy-Item (Join-Path $Bin 'Bar.exe') (Join-Path $Bin 'Nexus.exe') -Force }
    elseif (Test-Path (Join-Path $Root 'Bar.exe')) { $Bin = $Root; Copy-Item (Join-Path $Root 'Bar.exe') (Join-Path $Root 'Nexus.exe') -Force }
    else { Fail "Nexus.exe not found in $Root. Run build.ps1 first or extract the release zip." }
}

# The tasks first (so they cannot restart), then running processes from the install folders or bin folder.
foreach ($t in @($TaskName, $LegacyTaskName)) {
    $existingTask = Get-ScheduledTask -TaskName $t -ErrorAction SilentlyContinue
    if ($existingTask) {
        Disable-ScheduledTask -TaskName $t -ErrorAction SilentlyContinue | Out-Null
        Stop-ScheduledTask -TaskName $t -ErrorAction SilentlyContinue
    }
}
$running = @(Get-Process -Name 'Nexus','Bar' -ErrorAction SilentlyContinue | Where-Object {
    -not $_.Path -or (
        $_.Path.StartsWith($Target + '\', [StringComparison]::OrdinalIgnoreCase) -or 
        $_.Path.StartsWith($LegacyTarget + '\', [StringComparison]::OrdinalIgnoreCase) -or 
        $_.Path.StartsWith($Bin + '\', [StringComparison]::OrdinalIgnoreCase)
    )
})
foreach ($p in $running) {
    Write-Host "Stopping $($p.ProcessName) (pid $($p.Id))"
    Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
}
foreach ($p in $running) { try { $p.WaitForExit(15000) | Out-Null } catch { } }

# FFmpeg recorders
$ffmpegRunning = @(Get-Process -Name 'ffmpeg' -ErrorAction SilentlyContinue | Where-Object {
    $_.Path -and (
        [IO.Path]::GetDirectoryName($_.Path).Equals($Target, [StringComparison]::OrdinalIgnoreCase) -or 
        [IO.Path]::GetDirectoryName($_.Path).Equals($LegacyTarget, [StringComparison]::OrdinalIgnoreCase) -or 
        [IO.Path]::GetDirectoryName($_.Path).Equals($Bin, [StringComparison]::OrdinalIgnoreCase)
    )
})
foreach ($p in $ffmpegRunning) {
    Write-Host "Stopping ffmpeg (pid $($p.Id))"
    Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
}
foreach ($p in $ffmpegRunning) { try { $p.WaitForExit(15000) | Out-Null } catch { } }

# Stop ETW sessions (NexusFrames and legacy GameBarFrames)
try { & cmd.exe /c 'logman.exe stop NexusFrames -ets >nul 2>&1' } catch { }
try { & cmd.exe /c 'logman.exe stop GameBarFrames -ets >nul 2>&1' } catch { }

try {
    Write-Host "Copying files to $Target"
    New-Item -ItemType Directory -Force $Target | Out-Null
    Copy-Item -Path (Join-Path $Bin '*') -Destination $Target -Recurse -Force

    $lhm = Join-Path $Root 'third_party\lhm'
    if (Test-Path $lhm) { Get-ChildItem -Path $lhm -Filter *.dll -File | ForEach-Object { Copy-Item -Path $_.FullName -Destination $Target -Force } }
    if (-not (Test-Path (Join-Path $Target 'LibreHardwareMonitorLib.dll'))) {
        Write-Host 'WARNING: LibreHardwareMonitorLib.dll not found: Performance CPU/GPU readings will show "--" (see third_party\README.md)' -ForegroundColor Yellow
    }
    $licenses = Join-Path $Root 'third_party\licenses'
    if (Test-Path $licenses) {
        New-Item -ItemType Directory -Force (Join-Path $Target 'licenses') | Out-Null
        Copy-Item -Path (Join-Path $licenses '*') -Destination (Join-Path $Target 'licenses') -Force
    }
    $ffmpeg = Join-Path $Root 'third_party\ffmpeg\ffmpeg.exe'
    if (Test-Path $ffmpeg) {
        Copy-Item -Path $ffmpeg -Destination $Target -Force
        $lic = Join-Path $Root 'third_party\ffmpeg\LICENSE.txt'
        if (Test-Path $lic) { Copy-Item -Path $lic -Destination (Join-Path $Target 'FFmpeg-LICENSE.txt') -Force }
    }
    if (-not (Test-Path (Join-Path $Target 'ffmpeg.exe'))) {
        Write-Host 'WARNING: ffmpeg.exe not found: Record will be greyed ("Recorder not installed")' -ForegroundColor Yellow
    }
    foreach ($f in 'LICENSE', 'THIRD-PARTY-NOTICES.md', 'README.md') {
        $src = Join-Path $Root $f
        if (Test-Path $src) { Copy-Item -Path $src -Destination $Target -Force }
    }

    Write-Host "Registering the scheduled task '$TaskName' for $User"
    $exe = Join-Path $Target 'Nexus.exe'
    $action    = New-ScheduledTaskAction -Execute $exe -WorkingDirectory $Target
    $trigger   = New-ScheduledTaskTrigger -AtLogOn -User $User
    $principal = New-ScheduledTaskPrincipal -UserId $User -LogonType Interactive -RunLevel Highest
    $settings  = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
        -ExecutionTimeLimit ([TimeSpan]::Zero) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1) `
        -MultipleInstances IgnoreNew
    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings `
        -Description 'Starts Nexus (handheld quick settings companion) at logon.' -Force | Out-Null

    # Unregister legacy task if present
    if (Get-ScheduledTask -TaskName $LegacyTaskName -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $LegacyTaskName -Confirm:$false -ErrorAction SilentlyContinue
    }
}
catch {
    $why = $_.Exception.Message
    Fail "$why. Installation aborted."
}

Start-ScheduledTask -TaskName $TaskName
Write-Host "Nexus installed in $Target and started. It also starts at every logon of $User." -ForegroundColor Green
exit 0
