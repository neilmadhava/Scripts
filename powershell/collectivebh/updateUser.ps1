Import-Csv "updateUser.csv" |  ForEach-Object{
    # Get all the param values for a record
    $email = $_.upn
    $state = $_.state
    $streetAddress = $_.streetAddress
    $companyName = $_.companyName
    $physicalDelivery = $_.officeLocation

    # Get-AzureADUser -ObjectId $email | Select-Object -Property DisplayName,Mail # To get user's display name and email to confirm correct user is selected

    Write-Output "Updating user '$email' - State: '$state' StreetAddress:'$streetAddress' CompName: '$CompanyName' PhysicalDelivery: '$physicalDelivery'"
    Set-AzureADUser -ObjectId $email -State $state -StreetAddress "$streetAddress" -CompanyName "$companyName" -PhysicalDeliveryOfficeName $physicalDelivery
}


# Write-Output "Final Output - "
# Import-Csv "updateUser.csv" | ForEach-Object{ 
#     $email = $_.email
#     Get-AzureADUser -ObjectId $email | Select-Object -Property DisplayName,Mail,State,StreetAddress,CompanyName,PhysicalDeliveryOfficeName,
# }
