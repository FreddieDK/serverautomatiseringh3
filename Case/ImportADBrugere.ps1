# Importere ActiveDirectory ps module
Import-Module ActiveDirectory

# Efterspør bruger om CSV fil 
$CSVPath = Read-Host -Prompt "Angiv den fulde sti til CSV fil"

# Tjek om fil eksistere
if (-Not (Test-Path -Path $CSVPath)) {
    Write-Host "CSV fil ikke fundet $CSVPath. Venligst angiv den fulde sti" -ForegroundColor Red
    exit
}

# Efterspør bruger om AD OU path
$ADOUPath = Read-Host -Prompt "Angiv det fulde Active Directory OU sti (f.eks., OU=IT,DC=skole,DC=local)"

# Importer CSV data 
$Users = Import-Csv -Path $CSVPath -Delimiter ';'
$Domain = Read-Host -Prompt "Angiv domain (example.local)"

# Loop enhver bruger igennem fra csv
foreach ($User in $Users) {
    # Extract user details from the CSV
    $Username = $User.Username
    $Password = $User.Password | ConvertTo-SecureString -AsPlainText -Force
    $PhoneNumber = $User.Phonenumber
    $Mail = "$Username@$Domain" # Construct email using username@skole.local

    # Definer bruger variabler 
    $ADUserParams = @{
        SamAccountName = $Username
        UserPrincipalName = $Mail 
        Name = $Username
        GivenName = $Username
        Surname = "User"
        AccountPassword = $Password
        Enabled = $true
        EmailAddress = $Mail
        OfficePhone = $PhoneNumber
        Path = $ADOUPath 
    }

    # Opret bruger i AD
    try {
        New-ADUser @ADUserParams
        Write-Host "Successfully created user: $Username" -ForegroundColor Green
    } catch {
        Write-Host "Failed to create user: $Username. Error: $_" -ForegroundColor Red
    }
}

Write-Host "Bruger oprettet" -ForegroundColor Cyan


