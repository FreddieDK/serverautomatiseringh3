$Last30Days = (Get-Date).AddDays(-30)
Get-ADUser -Filter * -Properties WhenCreated | Where-Object { $_.WhenCreated -ge $Last30Days } | Select-Object Name, SamAccountName, WhenCreated
