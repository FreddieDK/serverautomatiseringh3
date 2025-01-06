# Importere ActiveDirectory ps module
Import-Module ActiveDirectory

# Efterspør bruger om CSV fil 
$CSVPath = Read-Host -Prompt "Enter the full path to the CSV file"

# Tjek om fil eksistere
if (-Not (Test-Path -Path $CSVPath)) {
    Write-Host "CSV file not found at $CSVPath. Please check the file path." -ForegroundColor Red
    exit
}

# Efterspør bruger om AD OU path
$ADOUPath = Read-Host -Prompt "Enter the Active Directory OU path (e.g., OU=IT,DC=skole,DC=local)"

# Importer CSV data 
$Users = Import-Csv -Path $CSVPath -Delimiter ';'
$Domain = Read-Host -Prompt "Enter the domain (example.local)"

# Loop through each user in the CSV file
foreach ($User in $Users) {
    # Extract user details from the CSV
    $Username = $User.Username
    $Password = $User.Password | ConvertTo-SecureString -AsPlainText -Force
    $PhoneNumber = $User.Phonenumber
    $Mail = "$Username@$Domain" # Construct email using username@skole.local

    # Define user properties
    $ADUserParams = @{
        SamAccountName = $Username
        UserPrincipalName = $Mail # UPN same as email
        Name = $Username
        GivenName = $Username
        Surname = "User"
        AccountPassword = $Password
        Enabled = $true
        EmailAddress = $Mail
        OfficePhone = $PhoneNumber
        Path = $ADOUPath # Use the user-specified OU path
    }

    # Create the user in AD
    try {
        New-ADUser @ADUserParams
        Write-Host "Successfully created user: $Username" -ForegroundColor Green
    } catch {
        Write-Host "Failed to create user: $Username. Error: $_" -ForegroundColor Red
    }
}

Write-Host "User import completed." -ForegroundColor Cyan

PAUSE
