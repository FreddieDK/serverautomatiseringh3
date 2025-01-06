# Define the folders to back up
$BackupFolders = @(
    "C:\FirmaFiler",  # Example folder 1
)

# Define the destination folder for backups
$BackupDestination = "\\192.168.25.10\Backup\serverbackups"

# Define the retention period (in days)
$RetentionDays = 14

# Create the destination folder if it doesn't exist
if (-Not (Test-Path -Path $BackupDestination)) {
    Write-Host "Creating backup destination folder: $BackupDestination"
    New-Item -ItemType Directory -Path $BackupDestination | Out-Null
}

# Create a timestamped archive filename
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$ComputerName = $env:COMPUTERNAME
$ArchiveFileName = "$ComputerName-$Timestamp.zip"
$ArchiveFilePath = Join-Path -Path $BackupDestination -ChildPath $ArchiveFileName

# Print start message
Write-Host "Starting backup of folders: $BackupFolders"
Write-Host "Backup destination: $BackupDestination"
Write-Host "Archive file: $ArchiveFilePath"

# Create the zip archive
try {
    Compress-Archive -Path $BackupFolders -DestinationPath $ArchiveFilePath -Force
    Write-Host "Backup completed successfully!" -ForegroundColor Green
} catch {
    Write-Host "Error during backup: $_" -ForegroundColor Red
    exit 1
}

# Delete old backups
try {
    Write-Host "Deleting backup files older than $RetentionDays days..."
    Get-ChildItem -Path $BackupDestination -Filter "*.zip" | Where-Object {
        $_.LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays)
    } | Remove-Item -Force
    Write-Host "Old backups deleted successfully!" -ForegroundColor Green
} catch {
    Write-Host "Error while deleting old backups: $_" -ForegroundColor Red
}

# Print end message
Write-Host "Backup process finished!" -ForegroundColor Cyan
