# Import-Module til AD cmdlets
Import-Module ActiveDirectory

# Valgmulighed for brugerinput
Write-Host "Vælg inputmetode:"
Write-Host "1: Indlæs fra CSV-fil"
Write-Host "2: Indtast manuelt"
$choice = Read-Host "Indtast dit valg (1 eller 2)"

if ($choice -eq "1") {
    # Indlæs fra CSV-fil
    $csvPath = Read-Host "Indtast stien til CSV-filen"
    if (Test-Path $csvPath) {
        $users = Import-Csv -Path $csvPath
        foreach ($user in $users) {
            # Opret AD-bruger fra CSV data
            try {
                New-ADUser -Navn $user.Name 
                           -Fornavn $user.GivenName 
                           -Efternavn $user.Surname 
                           -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) 
                           -Enabled $true
                Write-Host "Bruger $($user.Name) er oprettet."
            } catch {
                Write-Host "Fejl ved oprettelse af bruger $($user.Name): $_"
            }
        }
    } else {
        Write-Host "CSV-filen blev ikke fundet. Tjek filstien."
    }
} elseif ($choice -eq "2") {
    # Manuel indtastning
    $Name = Read-Host "Indtast navn"
    $GivenName = Read-Host "Indtast fornavn"
    $Surname = Read-Host "Indtast efternavn"
    $Password = Read-Host "Indtast brugerens kodeord"

    # Opret AD-bruger med indtastede data
    try {
        New-ADUser -Navn $Name 
                   -Fornavn $GivenName 
                   -Efternavn $Surname 
                   -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) 
                   -Enabled $true
        Write-Host "Bruger $Name er oprettet."
    } catch {
        Write-Host "Fejl ved oprettelse af bruger $($Name): $_"
    }
} else {
    Write-Host "Ugyldigt valg. Scriptet afsluttes."
}
