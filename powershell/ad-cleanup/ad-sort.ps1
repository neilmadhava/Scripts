# Change TargetOU variable
# Change imported CSV file

Import-Csv "sample.csv" | ForEach-Object {
    $User = $_.Description
    $Laptop = $_.Laptop
    # $TargetOU = "OU=Sample OU,DC=domain,DC=com"
    Write-Host "Moving $Laptop for $User to $TargetOU"
    try {
        $DistName = Get-ADComputer -Identity $Laptop
        Set-ADComputer -Identity $DistName -Description $User
        # Uncheck ProtectedFromAccidentalDeletion option for the laptop
        # Get-ADComputer -Identity $Laptop | Set-ADObject -ProtectedFromAccidentalDeletion $False
        # Move-ADObject -Identity $DistName -TargetPath $TargetOU
    }
    catch {
        Write-Host "!!! Could not move laptop for $User "
        Write-Host $_
    }
}