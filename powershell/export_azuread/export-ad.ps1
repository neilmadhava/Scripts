# Split path
$Path = (Split-Path -Parent $pwd) + "\" + (Split-Path -Leaf $pwd) 
# Create variable for the date stamp in log file
$LogDate = Get-Date -f yyyy-MM-dd-hhmm
$Csvfile = $Path + "\AllAzADUsers_$LogDate.csv"
Write-Host "Exporting data to $Path"

# Get all Azure AD users
$ADUsers = Get-ADUser -Filter * -SearchBase "DC=domain,DC=com" -Properties *

# Test with few users : comment out when not testing
# $AzADUsers = Get-AzureADUser -Identity abcd.xyz | Select-Object -Property *

# Iterating over each user and setting properties
$ADUsers | ForEach-Object {
    # $Manager = Get-AzureADUserManager -ObjectId $_.ObjectId
    # $Extension_Attributes = New-Object Psobject -Property $_.ExtensionProperty
    $user =[pscustomobject]@{
        # 'First name' = $_.GivenName
        # 'Last name' = $_.Surname
        'Displayname' = $_.DisplayName
        'EmployeeType' = $_.employeeType
        'Enabled' = $_.Enabled
        # 'UserPrincipalName' = $_.UserPrincipalName
        # 'StreetAddress' = $_.StreetAddress
        # 'City' = $_.City
        # 'State' = $_.State
        # 'PostalCode' = $_.PostalCode
        # 'Country' = $_.Country
        # 'JobTitle' = $_.JobTitle
        # 'Department' = $_.Department
        # 'CompanyName' = $_.CompanyName
        # 'Description' = $_.Description
        # 'PhysicalDeliveryOfficeName' = $_.PhysicalDeliveryOfficeName
        # 'TelephoneNumber' = $_.TelephoneNumber
        'Mail' = $_.EmailAddress
        # 'Mobile' = $_.Mobile
        # 'UserType' = $_.UserType
        # 'Dirsync' =  $_.DirSyncEnabled
        # 'Account status' = $_.AccountEnabled
        # 'Manager' = $Manager.displayname
        # 'EmployeeID' = $Extension_Attributes.employeeId
        # 'EmployeeID' = (Get-AzureADUserExtension -ObjectId $_.ObjectId).get_item("employeeId")
    }
    Write-Output "Getting details for: $($user.Displayname)"
    $user | Export-CSV $Csvfile -Append -NoTypeInformation -Force
}