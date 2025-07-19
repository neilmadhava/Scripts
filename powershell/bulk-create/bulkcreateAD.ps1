# Set a common password for all new users and onboard them in AD
$password = Read-Host -AsSecureString "Enter Password"

Import-Csv "sample.csv" |  ForEach-Object {
    $givenname = $_.FirstName
    $surname = $_.LastName
    $name = $_.DisplayName
    $samaccountname = $_.LogonName
    $emailaddress = $_.Email
    $manager = $_.Manager
    $manager = Get-ADUser -Filter "EmailAddress -eq '$manager'" | Select-Object -ExpandProperty DistinguishedName
    $jobtitle = $_.jobTitle
    $department = $_.department
    $country = $_.country
    $city = $_.city
    $postalcode = $_.postalCode
    $telephonenumber = $_.mobilePhone
    $path = $_.OU
    # $empid = $_.EmpId

    # $userinfo = Get-ADUser -Identity $samaccountname -ErrorAction SilentlyContinue 
    
    Write-Output "Creating user account for $samaccountname"
    try {
        New-ADUser `
        -GivenName $givenname `
        -Surname $surname `
        -DisplayName $name `
        -Name $name `
        -SamAccountName $samaccountname `
        -EmailAddress $emailaddress `
        -UserPrincipalName $emailaddress `
        -Manager $manager `
        -Description $jobtitle `
        -Title $jobtitle `
        -Department $department `
        -Country $country `
        -City $city `
        -PostalCode $postalcode `
        -OtherAttributes @{'telephoneNumber'=$telephonenumber} `
        -Accountpassword $password `
        -Enabled $true `
        -ChangePasswordAtLogon $true `
        -Path $path
    }
    catch {
        Write-Output $Error.Exception.Message
    }
}