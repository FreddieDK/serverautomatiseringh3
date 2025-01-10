
# Skaffer total fysisk RAM via performance counters (i MB)
$totalRam = (Get-Counter '\Memory\Committed Bytes').CounterSamples.CookedValue / 1MB
$startTime = Get-Date
$logDirectory = "C:\Logs"

# Sikre mappen til log findes
if (-not (Test-Path $logDirectory)) {
    New-Item -ItemType Directory -Path $logDirectory | Out-Null
}

# Genere et tidsstempelet log fil navn
$timestamp = $startTime.ToString("yyyyMMdd_HHmmss")
$logFile = Join-Path $logDirectory "SystemMetrics_$timestamp.csv"

# Beskriv TXT headers
"Timestamp;CPU (%);Available Memory (MB);Available Memory (%);Total Disk Space (GB);Used Disk Space (GB);Disk Usage (%);Uptime(Hours)" | Out-File -FilePath $logFile -Encoding UTF8

while ($true) {
    $currentTime = Get-Date

    # Stop scriptet efter 24 timer
    if (($currentTime - $startTime).TotalHours -ge 24) {
        Write-Host "24 hours elapsed. Stopping the script."
        break
    }

    # Hent system målinger
    $date = $currentTime.ToString("yyyy-MM-dd HH:mm:ss")
    $cpuTime = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $availMem = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
    $availMemPercent = ($availMem / $totalRam) * 100

    # Hent disk info
    $disk = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Name -eq "C" }
    $totalDisk = [math]::Round($disk.Used + $disk.Free / 1GB, 2)
    $usedDisk = [math]::Round($disk.Used / 1GB, 2)
    $diskUsagePercent = [math]::Round(($disk.Used / ($disk.Used + $disk.Free)) * 100, 2)

    # Hent uptime
    $uptime = ((Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime).TotalHours
    $uptime = $uptime -replace ',' -replace '.'

    # Formater log entry
    $logEntry = "$date;$($cpuTime.ToString("#,0.000"));$($availMem.ToString("N0"));$($availMemPercent.ToString("#,0.0"));$totalDisk;$usedDisk;$diskUsagePercent;$uptime"

    # Tilføj log entry til CSV fil
    $logEntry | Out-File -FilePath $logFile -Append -Encoding UTF8

    # Fremvis de nuværende målinger i consollen
    Write-Host "$date > CPU: $($cpuTime.ToString("#,0.000"))%, Avail. Mem.: $($availMem.ToString("N0"))MB ($($availMemPercent.ToString("#,0.0"))%), Disk: $usedDisk GB/$totalDisk GB ($diskUsagePercent%), Uptime(Hours): $uptime"

    # Pause i 2 sekunder før næste iteration
    Start-Sleep -s 2
}