$CurrentDirectory = Get-Location
$InputCSVPath = Join-Path -Path $CurrentDirectory -ChildPath "csv.csv"


# Get the directory and filename of the input file
$InputFolder = Split-Path -Path $InputCSVPath
$InputFileName = [System.IO.Path]::GetFileNameWithoutExtension($InputCSVPath)
$InputFileExtension = [System.IO.Path]::GetExtension($InputCSVPath)

# Generate the output file name using the current date and time
$CurrentDateTime = Get-Date -Format "yyyyMMdd-HHmmss"
$OutputFileName = "$InputFileName-$CurrentDateTime$InputFileExtension"
$OutputCSVPath = Join-Path -Path $InputFolder -ChildPath $OutputFileName

# Import the CSV data
$Data = Import-Csv -Path $InputCSVPath -Delimiter ';'

# Process the data and obfuscate the Sensitive_Data field
$ProcessedData = $Data | ForEach-Object {
    $ObfuscatedData = $_.Sensitive_Data -replace '^(\d{2}).+', '$1************'
    [PSCustomObject]@{
        Name           = $_.Name
        Hobby          = $_.Hobby
        Level          = $_.Level
        Sensitive_Data = $ObfuscatedData
    }
}

# Export the processed data to the new CSV file
$ProcessedData | Export-Csv -Path $OutputCSVPath -Delimiter ';' -NoTypeInformation

# Confirm the operation
Write-Host "Processed data has been saved to $OutputCSVPath" -ForegroundColor Green

PAUSE
