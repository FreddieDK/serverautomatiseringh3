# Importer Active Directory-modulet
Import-Module ActiveDirectory

# Beregn datoen for 30 dage siden
$Date30DaysAgo = (Get-Date).AddDays(-30)

# Hent alle brugere, der er oprettet inden for de sidste 30 dage
$usersToDelete = Get-ADUser -Filter {whenCreated -ge $Date30DaysAgo} -Properties whenCreated

# Hvis der findes brugere, der er oprettet inden for de sidste 30 dage, slet dem
if ($usersToDelete) {
    foreach ($user in $usersToDelete) {
        try {
            # Slet brugeren
            Remove-ADUser -Identity $user.DistinguishedName -Confirm:$false
            Write-Host "Bruger $($user.SamAccountName) er blevet slettet."
        } catch {
            Write-Host "Fejl ved sletning af bruger $($user.SamAccountName): $_"
        }
    }
} else {
    Write-Host "Der er ingen brugere oprettet indenfor de sidste 30 dage."
}
