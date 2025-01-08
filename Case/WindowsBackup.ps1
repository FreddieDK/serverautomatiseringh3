# Definer mapperne til backup
$BackupFolders = @(
    "C:\FirmaFiler" # Example folder 1
)

# Definer stien til backup folderen
$BackupDestination = "\\192.168.25.10\Backup\serverbackups"

# Definer retention perioden (i dage)
$RetentionDays = 14

# Definer log fil stien
$LogFilePath = "C:\BackupLog.txt"

# Funktion til log beskeder
function Log-Message {
    param (
        [string]$Message,
        [string]$Type = "INFO"  # INFO, ERROR, WARNING
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$Timestamp [$Type] $Message"
    Add-Content -Path $LogFilePath -Value $LogEntry
    Write-Host $LogEntry
}

# Skab et tidstemplet arkiv fil-navn
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$ComputerName = $env:COMPUTERNAME
$ArchiveFileName = "$ComputerName-$Timestamp.zip"
$ArchiveFilePath = Join-Path -Path $BackupDestination -ChildPath $ArchiveFileName

# Udskriv start besked
Log-Message "Starting backup of folders: $BackupFolders"
Log-Message "Backup destination: $BackupDestination"
Log-Message "Archive file: $ArchiveFilePath"

# Skab zip arkivet
try {
    Compress-Archive -Path $BackupFolders -DestinationPath $ArchiveFilePath -Force
    Log-Message "Backup completed successfully!" "INFO"
} catch {
    Log-Message "Error during backup: $_" "ERROR"
    exit 1
}

# Slet ældre backups
try {
    Log-Message "Deleting backup files older than $RetentionDays days..."
    Get-ChildItem -Path $BackupDestination -Filter "*.zip" | Where-Object {
        $_.LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays) #Check om backups er less than accepted age
    } | Remove-Item -Force
    Log-Message "Old backups deleted successfully!" "INFO"
} catch {
    Log-Message "Error while deleting old backups: $_" "ERROR"
}

# Udskriv slut besked
Log-Message "Backup process finished!" "INFO"
