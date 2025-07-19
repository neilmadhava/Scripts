$file = import-csv "sample.csv"
foreach ($record in $file)
{
    $upn = $record.upn
    $updated_upn = $upn.ToLower()
    # $email = $record.email.ToLower()
    try {
        Write-host Setting $upn to $updated_upn
        Get-ADUser -Filter "UserPrincipalName -eq '$upn'" | Set-ADUser -UserPrincipalName $updated_upn
        Write-host "Success!"
    }
    catch {
        Write-Host "!!! Could not update email for $upn" -ForegroundColor Red
        Write-Host $Error.Exception.Message
    }
}