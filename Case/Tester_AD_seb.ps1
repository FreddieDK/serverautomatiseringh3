Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Opret hovedvinduet
$form = New-Object System.Windows.Forms.Form
$form.Text = "AD Bruger Oprettelse"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"

# Tilføj en tekstboks til output
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.Size = New-Object System.Drawing.Size(350, 150)
$outputBox.Location = New-Object System.Drawing.Point(20, 80)
$form.Controls.Add($outputBox)

# Funktion til CSV-indlæsning
function LoadFromCSV {
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "CSV Files (*.csv)|*.csv|All Files (*.*)|*.*"
    $openFileDialog.ShowDialog() | Out-Null
    $csvPath = $openFileDialog.FileName
    if ($csvPath -ne "") {
        try {
            $users = Import-Csv -Path $csvPath -Delimiter ";"
            foreach ($user in $users) {
                try {
                    New-ADUser -Name $user.Name `
                               -GivenName $user.GivenName `
                               -Surname $user.Surname `
                               -SamAccountName $user.SamAccountName `
                               -UserPrincipalName "$($user.SamAccountName)@test.local" `
                               -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force)
                    Enable-ADAccount -Identity $user.SamAccountName
                    $outputBox.AppendText("Bruger $($user.Name) oprettet og aktiveret.`r`n")
                } catch {
                    $outputBox.AppendText("Fejl ved oprettelse af bruger $($user.Name): $_`r`n")
                }
            }
        } catch {
            $outputBox.AppendText("Fejl ved indlæsning af CSV-fil: $_`r`n")
        }
    }
}

# Funktion til manuel indtastning
function ManualEntry {
    $inputForm = New-Object System.Windows.Forms.Form
    $inputForm.Text = "Manuel Bruger Oprettelse"
    $inputForm.Size = New-Object System.Drawing.Size(400, 400)
    $inputForm.StartPosition = "CenterScreen"

    # Felter til brugerdata
    $labels = @("Navn", "Fornavn", "Efternavn", "SamAccountName", "Password")
    $fields = @{}

    for ($i = 0; $i -lt $labels.Length; $i++) {
        $label = New-Object System.Windows.Forms.Label
        $label.Text = $labels[$i]
        $label.Location = New-Object System.Drawing.Point(20, 20 + ($i * 40))
        $inputForm.Controls.Add($label)

        $textBox = New-Object System.Windows.Forms.TextBox
        $textBox.Location = New-Object System.Drawing.Point(150, 20 + ($i * 40))
        $fields[$labels[$i]] = $textBox
        $inputForm.Controls.Add($textBox)
    }

    # Opret knap
    $submitButton = New-Object System.Windows.Forms.Button
    $submitButton.Text = "Opret Bruger"
    $submitButton.Location = New-Object System.Drawing.Point(150, 240)
    $submitButton.Add_Click({
        try {
            New-ADUser -Name $fields["Navn"].Text `
                       -GivenName $fields["Fornavn"].Text `
                       -Surname $fields["Efternavn"].Text `
                       -SamAccountName $fields["SamAccountName"].Text `
                       -UserPrincipalName "$($fields["SamAccountName"].Text)@test.local" `
                       -AccountPassword (ConvertTo-SecureString $fields["Password"].Text -AsPlainText -Force)
            Enable-ADAccount -Identity $fields["SamAccountName"].Text
            $outputBox.AppendText("Bruger $($fields["Navn"].Text) oprettet og aktiveret.`r`n")
            $inputForm.Close()
        } catch {
            $outputBox.AppendText("Fejl ved oprettelse af bruger $($fields["Navn"].Text): $_`r`n")
        }
    })
    $inputForm.Controls.Add($submitButton)

    $inputForm.ShowDialog()
}

# Funktion til hjælp
function ShowHelp {
    $helpMessage = @"
Dette script giver dig mulighed for at oprette brugere i Active Directory på to måder:

1. Indlæsning fra en CSV-fil: Du angiver stien til en CSV-fil, der indeholder brugeroplysninger. Scriptet opretter brugerne automatisk baseret på denne fil.

2. Manuel indtastning: Du indtaster brugeroplysninger direkte i GUI'en, og scriptet opretter brugeren.

CSV-filen skal have følgende kolonner: Name, GivenName, Surname, SamAccountName og Password.

Sørg for, at du har de nødvendige rettigheder til at oprette brugere i Active Directory.
"@
    [System.Windows.Forms.MessageBox]::Show($helpMessage, "Hjælp")
}

# Knapper i hovedmenuen
$buttons = @("Indlæs fra CSV", "Manuel Indtastning", "Hjælp", "Afslut")
$actions = @([scriptblock]::Create("LoadFromCSV"), 
             [scriptblock]::Create("ManualEntry"), 
             [scriptblock]::Create("ShowHelp"), 
             [scriptblock]::Create({ $form.Close() }))

for ($i = 0; $i -lt $buttons.Length; $i++) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $buttons[$i]
    $button.Size = New-Object System.Drawing.Size(150, 30)
    $button.Location = New-Object System.Drawing.Point(20, 20 + ($i * 40))
    $button.Add_Click($actions[$i])
    $form.Controls.Add($button)
}

$form.ShowDialog()
