# Get total physical memory using performance counters (in MB)
$totalRam = (Get-Counter '\Memory\Committed Bytes').CounterSamples.CookedValue / 1MB
$startTime = Get-Date
$logDirectory = "C:\Logs"

# Ensure the log directory exists
if (-not (Test-Path $logDirectory)) {
    New-Item -ItemType Directory -Path $logDirectory | Out-Null
}

# Generate a timestamped log file name
$timestamp = $startTime.ToString("yyyyMMdd_HHmmss")
$logFile = Join-Path $logDirectory "SystemMetrics_$timestamp.csv"

# Write CSV headers
"Timestamp;CPU (%);Available Memory (MB);Available Memory (%)" | Out-File -FilePath $logFile -Encoding UTF8

while ($true) {
    $currentTime = Get-Date
    
    # Stop the script after 24 hours
    if (($currentTime - $startTime).TotalHours -ge 24) {
        Write-Host "24 hours elapsed. Stopping the script."
        break
    }

    # Collect system metrics
    $date = $currentTime.ToString("yyyy-MM-dd HH:mm:ss")
    $cpuTime = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $availMem = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
    $availMemPercent = ($availMem / $totalRam) * 100
    ((get-date) – (gcim Win32_OperatingSystem).LastBootUpTime).TotalHours

    # Format the log entry
    $logEntry = "$date;$($cpuTime.ToString("#,0.000"));$($availMem.ToString("N0"));$($availMemPercent.ToString("#,0.0"))"

    # Append the log entry to the CSV file
    $logEntry | Out-File -FilePath $logFile -Append -Encoding UTF8

    # Display the current metrics in the console
    Write-Host "$date > CPU: $($cpuTime.ToString("#,0.000"))%, Avail. Mem.: $($availMem.ToString("N0"))MB ($($availMemPercent.ToString("#,0.0"))%)"

    # Pause for 2 seconds before the next iteration
    Start-Sleep -s 2
}

PAUSE
