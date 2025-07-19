# use the script to export Azure data with custom fields not available directly in Azure GUI

# Split path
$Path = (Split-Path -Parent $pwd) + "\" + (Split-Path -Leaf $pwd) 
# Create variable for the date stamp in log file
$LogDate = Get-Date -f yyyy-MM-dd-hhmm
$Csvfile = $Path + "\AllAzADUsers_$LogDate.csv"
Write-Host "Exporting data to $Path"

# Get all Azure AD users
$AzADUsers = Get-AzureADUser -All $true | Select-Object -Property *

# Test with few users : comment out when not testing
# $AzADUsers = Get-AzureADUser -Top 50 | Select-Object -Property *

# Iterating over each user and setting properties
$AzADUsers | ForEach-Object {
    $Manager = Get-AzureADUserManager -ObjectId $_.ObjectId
    $Extension_Attributes = New-Object Psobject -Property $_.ExtensionProperty
    $user =[pscustomobject]@{
        'First name' = $_.GivenName
        'Last name' = $_.Surname
        'Displayname' = $_.DisplayName
        'UserPrincipalName' = $_.UserPrincipalName
        'StreetAddress' = $_.StreetAddress
        'City' = $_.City
        'State' = $_.State
        'PostalCode' = $_.PostalCode
        'Country' = $_.Country
        'JobTitle' = $_.JobTitle
        'Department' = $_.Department
        'CompanyName' = $_.CompanyName
        'Description' = $_.Description
        'PhysicalDeliveryOfficeName' = $_.PhysicalDeliveryOfficeName
        'TelephoneNumber' = $_.TelephoneNumber
        'Mail' = $_.Mail
        'Mobile' = $_.Mobile
        'UserType' = $_.UserType
        'Dirsync' =  $_.DirSyncEnabled
        'Account status' = $_.AccountEnabled
        'Manager' = $Manager.displayname
        'EmployeeID' = $Extension_Attributes.employeeId
        # 'EmployeeID' = (Get-AzureADUserExtension -ObjectId $_.ObjectId).get_item("employeeId")
    }
    Write-Output "Getting details for: $($user.Displayname)"
    $user | Export-CSV $Csvfile -Append -NoTypeInformation -Force
}