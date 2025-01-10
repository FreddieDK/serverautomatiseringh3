<#
.SYNOPSIS
Dette script opretter brugere i AD. 

Ved start af script bliver brugeren mødt af 3 valgmuligheder

1: "Indlæs fra CSV-fil" - Brugeren skal indtaste filstien til CSV-filen, hvorefter at sciptet læser og opretter brugere ud fra dataen.
2: "Indtast manuelt" - Brugeren skal manuelt indtaste data udfra de prompter der kommer i terminalen, hvorefter scriptet opretter brugeren.
3: "Hjælp - Beskrivelse af scriptet" - Hjælpemenu der beskriver hvad de 2 valg gør, samt kontaktinformation for udvikleren af scriptet.

.NOTES
AUTHOR: Sebastian Nielsen - seba214h@zbc.dk

Version: 1.1
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Import-Module til AD cmdlets
Import-Module ActiveDirectory

# Funktion: Opret brugere fra CSV-fil
function OpretBrugerFraCSV {
    param (
        [string]$csvPath
    )
    if (Test-Path $csvPath) {
        $users = Import-Csv -Path $csvPath -Delimiter ";"
        # Valider kolonner i CSV
        $requiredColumns = @("Name", "GivenName", "Surname", "SamAccountName", "Password")
        $csvColumns = $users[0].PSObject.Properties.Name
        if (-not $requiredColumns -in $csvColumns) {
            Write-Host "CSV-filen mangler en eller flere krævede kolonner: $($requiredColumns -join ", ")"
            return
        }
        foreach ($user in $users) {
            try {
                New-ADUser -Name $user.Name `
                           -GivenName $user.GivenName `
                           -Surname $user.Surname `
                           -SamAccountName $user.SamAccountName `
                           -UserPrincipalName "$($user.SamAccountName)@test.local" `
                           -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
                           -PassThru | Enable-ADAccount
                Write-Host "Bruger $($user.Name) er oprettet og aktiveret."
            } catch {
                Write-Host "Fejl ved oprettelse af bruger $($user.Name): $_"
            }
        }
    } else {
        Write-Host "CSV-filen blev ikke fundet. Tjek filstien."
    }
}

# Funktion: Opret bruger manuelt
function OpretBrugerManuelt {
    $Name = Read-Host "Indtast navn"
    $GivenName = Read-Host "Indtast fornavn"
    $Surname = Read-Host "Indtast efternavn"
    $SamAccountName = Read-Host "Indtast brugernavn (SamAccountName)"
    $Password = Read-Host "Indtast brugerens kodeord" -AsSecureString

    try {
        New-ADUser -Name $Name `
                   -GivenName $GivenName `
                   -Surname $Surname `
                   -SamAccountName $SamAccountName `
                   -UserPrincipalName "$SamAccountName@test.local" `
                   -AccountPassword $Password `
                   -PassThru | Enable-ADAccount
        Write-Host "Bruger $Name er oprettet og aktiveret."
    } catch {
        Write-Host "Fejl ved oprettelse af bruger $($user.Name): $_"
    }
}

# Hovedprogram
while ($true) {
    # Menu
    Write-Host "Vælg inputmetode:"
    Write-Host "1: Indlæs fra CSV-fil"
    Write-Host "2: Indtast manuelt"
    Write-Host "3: Hjælp - Beskrivelse af scriptet"
    Write-Host "4: Afslut"
    $choice = Read-Host "Indtast dit valg (1, 2, 3 eller 4)"

    switch ($choice) {
        "1" {
            $csvPath = Read-Host "Indtast stien til CSV-filen"
            OpretBrugerFraCSV -csvPath $csvPath
        }
        "2" {
            OpretBrugerManuelt
        }
        "3" {
            Write-Host "Dette script giver dig mulighed for at oprette brugere i Active Directory på to måder:"
            Write-Host "`n1. Indlæsning fra en CSV-fil: Du angiver stien til en CSV-fil, der indeholder brugeroplysninger. Scriptet opretter brugerne automatisk baseret på denne fil."
            Write-Host "`n2. Manuel indtastning: Du indtaster brugeroplysninger direkte i terminalen, og scriptet opretter brugeren."
            Write-Host "`nCSV-filen skal have følgende kolonner: Name, GivenName, Surname, SamAccountName og Password."
            Write-Host "`nSørg for, at du har de nødvendige rettigheder til at oprette brugere i Active Directory."
            Write-Host "`nKontakt Sebastian ved fejl i scriptet på seba214h@zbc.dk"
        }
        "4" {
            Write-Host "Scriptet afsluttes."
            break
        }
        default {
            Write-Host "Ugyldigt valg. Prøv igen."
        }
    }
}
