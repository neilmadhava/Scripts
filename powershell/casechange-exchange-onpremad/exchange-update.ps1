Import-Csv "sample.csv" | ForEach-Object {
    $upn = $_.upn
    $email = $_.upn.ToLower()
    try {
        Write-host Setting $upn to $email
        Set-MSOLUserPrincipalName -UserPrincipalName $upn -NewUserPrincipalName $email
    }
    catch {
        Write-Host "!!! Could not update email for $upn" -ForegroundColor Red
        Write-Host $Error.Exception.Message
    }
}