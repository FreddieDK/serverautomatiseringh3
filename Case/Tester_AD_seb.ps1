# Import-Module til AD cmdlets
Import-Module ActiveDirectory

# Start en løkke for at give flere valgmuligheder
while ($true) {
    # Valgmulighed for brugerinput
    Write-Host "Vælg inputmetode:"
    Write-Host "1: Indlæs fra CSV-fil"
    Write-Host "2: Indtast manuelt"
    Write-Host "3: Hjælp - Beskrivelse af scriptet"
    Write-Host "4: Afslut"
    $choice = Read-Host "Indtast dit valg (1, 2, 3 eller 4)"

    if ($choice -eq "1") {
        # Indlæs fra CSV-fil
        $csvPath = Read-Host "Indtast stien til CSV-filen"
        if (Test-Path $csvPath) {
            $users = Import-Csv -Path $csvPath -Delimiter ";"
            foreach ($user in $users) {
                # Opret AD-bruger fra CSV data
                try {
                    # Opret brugeren uden password
                    New-ADUser -Name $user.Name `
                               -GivenName $user.GivenName `
                               -Surname $user.Surname `
                               -SamAccountName $user.SamAccountName `
                               -UserPrincipalName "$($user.SamAccountName)@test.local" `
                               -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) 
                               -Enabled $true `
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
        $SamAccountName = Read-Host "Indtast brugernavn (SamAccountName)"
        $Password = Read-Host "Indtast brugerens kodeord"

        # Opret AD-bruger med indtastede data
        try {
            # Opret brugeren uden password
            New-ADUser -Name $Name `
                       -GivenName $GivenName `
                       -Surname $Surname `
                       -SamAccountName $SamAccountName `
                       -UserPrincipalName "$SamAccountName@test.local" `
                       -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) 
                       -Enabled $true `
                       -PassThru


            Write-Host "Bruger $Name er oprettet."
        } catch {
            Write-Host "Fejl ved oprettelse af bruger $($Name): $_"
        }

    } elseif ($choice -eq "3") {
        # Hjælp - Beskrivelse af scriptet
        Write-Host "Dette script giver dig mulighed for at oprette brugere i Active Directory på to måder:"
        Write-Host "`n1. Indlæsning fra en CSV-fil: Du angiver stien til en CSV-fil, der indeholder brugeroplysninger. Scriptet opretter brugerne automatisk baseret på denne fil."

        Write-Host "`n2. Manuel indtastning: Du indtaster brugeroplysninger direkte i terminalen, og scriptet opretter brugeren."

        Write-Host "`nCSV-filen skal have følgende kolonner: Name, GivenName, Surname og Password."

        Write-Host "`nSørg for, at du har de nødvendige rettigheder til at oprette brugere i Active Directory."

        Write-Host "`nKontakt Sebastian ved fejl i scriptet på seba214h@zbc.dk"

    } elseif ($choice -eq "4") {
        # Afslut scriptet
        Write-Host "Scriptet afsluttes."
        break

    } else {
        Write-Host "Ugyldigt valg. Scriptet afsluttes."
    }
}
