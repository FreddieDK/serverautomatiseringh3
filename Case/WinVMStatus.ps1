#https://stackoverflow.com/questions/6298941/how-do-i-find-the-cpu-and-ram-usage-using-powershell
$totalRamString = (systeminfo | Select-String 'Total Physical Memory:').ToString().Split(':')[1].Trim()
$totalRam = [double]($totalRamString -replace '[^\d.]', '') # Uddrag numerisk del and omdan til double
$totalRam = $totalRam -replace ',' -replace ''
$startTime = Get-Date
$logDirectory = "C:\Logs"

# Sikre at mappen til log findes
if (-not (Test-Path $logDirectory)) {
    New-Item -ItemType Directory -Path $logDirectory | Out-Null
}

# Genere et tidsstempelet log fil navn
$timestamp = $startTime.ToString("yyyyMMdd_HHmmss")
$logFile = Join-Path $logDirectory "SystemMetrics_$timestamp.csv"

# Beskriv CSV headers
"Timestamp;CPU (%);Available Memory (MB);Available Memory (%)" | Out-File -FilePath $logFile -Encoding UTF8

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
    ((get-date) – (gcim Win32_OperatingSystem).LastBootUpTime).TotalHours

    # Formater log entry
    $logEntry = "$date;$($cpuTime.ToString("#,0.000"));$($availMem.ToString("N0"));$($availMemPercent.ToString("#,0.0"))"

    # Tilføj log entry til CSV filen
    $logEntry | Out-File -FilePath $logFile -Append -Encoding UTF8

    # Fremvis de nuværende målinger i consollen
    Write-Host "$date > CPU: $($cpuTime.ToString("#,0.000"))%, Avail. Mem.: $($availMem.ToString("N0"))MB ($($availMemPercent.ToString("#,0.0"))%)"

    # Pause i 2 sekunder før næste iteration
    Start-Sleep -s 2
}
