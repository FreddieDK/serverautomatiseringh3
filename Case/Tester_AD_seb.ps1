# Importer nødvendige moduler
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Import-Module ActiveDirectory

# Opret formular
$form = New-Object System.Windows.Forms.Form
$form.Text = "AD User Creation Tool"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"

# Label og tekstbokse til input
$lblName = New-Object System.Windows.Forms.Label
$lblName.Text = "Navn:"
$lblName.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($lblName)

$txtName = New-Object System.Windows.Forms.TextBox
$txtName.Location = New-Object System.Drawing.Point(150, 20)
$txtName.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($txtName)

$lblGivenName = New-Object System.Windows.Forms.Label
$lblGivenName.Text = "Fornavn:"
$lblGivenName.Location = New-Object System.Drawing.Point(20, 60)
$form.Controls.Add($lblGivenName)

$txtGivenName = New-Object System.Windows.Forms.TextBox
$txtGivenName.Location = New-Object System.Drawing.Point(150, 60)
$txtGivenName.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($txtGivenName)

$lblSurname = New-Object System.Windows.Forms.Label
$lblSurname.Text = "Efternavn:"
$lblSurname.Location = New-Object System.Drawing.Point(20, 100)
$form.Controls.Add($lblSurname)

$txtSurname = New-Object System.Windows.Forms.TextBox
$txtSurname.Location = New-Object System.Drawing.Point(150, 100)
$txtSurname.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($txtSurname)

$lblSamAccountName = New-Object System.Windows.Forms.Label
$lblSamAccountName.Text = "Brugernavn (SamAccountName):"
$lblSamAccountName.Location = New-Object System.Drawing.Point(20, 140)
$form.Controls.Add($lblSamAccountName)

$txtSamAccountName = New-Object System.Windows.Forms.TextBox
$txtSamAccountName.Location = New-Object System.Drawing.Point(150, 140)
$txtSamAccountName.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($txtSamAccountName)

$lblPassword = New-Object System.Windows.Forms.Label
$lblPassword.Text = "Adgangskode:"
$lblPassword.Location = New-Object System.Drawing.Point(20, 180)
$form.Controls.Add($lblPassword)

$txtPassword = New-Object System.Windows.Forms.TextBox
$txtPassword.Location = New-Object System.Drawing.Point(150, 180)
$txtPassword.Size = New-Object System.Drawing.Size(200, 20)
$txtPassword.PasswordChar = '*'
$form.Controls.Add($txtPassword)

# OutputBox til logning
$OutputBox = New-Object System.Windows.Forms.TextBox
$OutputBox.Location = New-Object System.Drawing.Point(20, 220)
$OutputBox.Size = New-Object System.Drawing.Size(550, 100)
$OutputBox.Multiline = $true
$OutputBox.ScrollBars = "Vertical"
$form.Controls.Add($OutputBox)

# Knappen til oprettelse
$btnCreate = New-Object System.Windows.Forms.Button
$btnCreate.Text = "Opret Bruger"
$btnCreate.Location = New-Object System.Drawing.Point(150, 340)
$form.Controls.Add($btnCreate)

# Funktion til at oprette AD-bruger
$btnCreate.Add_Click({
    $Name = $txtName.Text
    $GivenName = $txtGivenName.Text
    $Surname = $txtSurname.Text
    $SamAccountName = $txtSamAccountName.Text
    $Password = $txtPassword.Text

    if (-not ($Name -and $GivenName -and $Surname -and $SamAccountName -and $Password)) {
        $OutputBox.AppendText("Alle felter skal udfyldes.`r`n")
        return
    }

    try {
        # Opret bruger
        New-ADUser -Name $Name `
                   -GivenName $GivenName `
                   -Surname $Surname `
                   -SamAccountName $SamAccountName `
                   -UserPrincipalName "$SamAccountName@test.local" `
                   -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
                   -Enabled $true
        $OutputBox.AppendText("Bruger $Name er oprettet.`r`n")
    } catch {
        $OutputBox.AppendText("Fejl ved oprettelse af bruger $($Name): $_")
    }
})

# Vis formularen
$form.Add_Shown({$form.Activate()})
[System.Windows.Forms.Application]::Run($form)
