Import-Csv "clinician2associate.csv" |  ForEach-Object{
    # Get all the param values for a record
    $email = $_.email
    # Get-AzureADUser -ObjectId $email | Select-Object -Property DisplayName,Mail # To get user's display name and email to confirm correct user is selected

    Write-Output "Updating user '$email' - PhysicalDelivery: 'Associate'"
    Set-AzureADUser -ObjectId $email -PhysicalDeliveryOfficeName "Associate"
}


# Write-Output "Final Output - "
# Import-Csv "updateUser.csv" | ForEach-Object{ 
#     $email = $_.email
#     Get-AzureADUser -ObjectId $email | Select-Object -Property DisplayName,Mail,State,StreetAddress,CompanyName,PhysicalDeliveryOfficeName,
# }
