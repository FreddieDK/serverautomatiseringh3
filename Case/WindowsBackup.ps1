# Define the folders to back up
$BackupFolders = @(
    "C:\FirmaFiler" # Example folder 1
)

# Define the destination folder for backups
$BackupDestination = "\\192.168.25.10\Backup\serverbackups"

# Define the retention period (in days)
$RetentionDays = 14

# Define the log file path
$LogFilePath = Join-Path -Path C:\ -ChildPath "BackupLog.txt"

# Function to log messages
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

# Create the destination folder if it doesn't exist
if (-Not (Test-Path -Path $BackupDestination)) {
    Log-Message "Creating backup destination folder: $BackupDestination"
    New-Item -ItemType Directory -Path $BackupDestination | Out-Null
}

# Create a timestamped archive filename
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$ComputerName = $env:COMPUTERNAME
$ArchiveFileName = "$ComputerName-$Timestamp.zip"
$ArchiveFilePath = Join-Path -Path $BackupDestination -ChildPath $ArchiveFileName

# Print start message
Log-Message "Starting backup of folders: $BackupFolders"
Log-Message "Backup destination: $BackupDestination"
Log-Message "Archive file: $ArchiveFilePath"

# Create the zip archive
try {
    Compress-Archive -Path $BackupFolders -DestinationPath $ArchiveFilePath -Force
    Log-Message "Backup completed successfully!" "INFO"
} catch {
    Log-Message "Error during backup: $_" "ERROR"
    exit 1
}

# Delete old backups
try {
    Log-Message "Deleting backup files older than $RetentionDays days..."
    Get-ChildItem -Path $BackupDestination -Filter "*.zip" | Where-Object {
        $_.LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays)
    } | Remove-Item -Force
    Log-Message "Old backups deleted successfully!" "INFO"
} catch {
    Log-Message "Error while deleting old backups: $_" "ERROR"
}

# Print end message
Log-Message "Backup process finished!" "INFO"
