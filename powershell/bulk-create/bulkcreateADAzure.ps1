param([string]$nullid="false")

if (Get-Module -ListAvailable -Name AzureADPreview) {
    Import-Module AzureADPreview -Force
} 
else {
    Install-Module AzureADPreview -Scope CurrentUser -Force -AllowClobber
}

Import-Csv "sample.csv" |  ForEach-Object {
    $empid = $_.EmpId
    if ($empid -or $nullid){}else{
        Write-Host "!!! $name has EmpId Field as null! Exiting." -ForegroundColor Red
        if ($nullid -ne "true") {
            Write-Host "To allow execution with null Empid, use: './bulkcreateADAzure.ps1 -nullid true'"
            exit
        }
    }
}

$password = Read-Host -AsSecureString "Enter Password to set for the accounts: "

Import-Csv "sample.csv" |  ForEach-Object {
    $givenname = $_.FirstName
    $surname = $_.LastName
    $name = $_.DisplayName
    $samaccountname = $_.LogonName
    $emailaddress = $_.Email
    $manager = $_.Manager
    try {
        $manager = Get-ADUser -Filter "EmailAddress -eq '$manager'" | Select-Object -ExpandProperty DistinguishedName
    }
    catch {
        Write-Host "!!! Couldn't get manager data for $givenname $surname" -ForegroundColor Red
    }
    $jobtitle = $_.jobTitle
    $department = $_.department
    $country = $_.country
    $city = $_.city
    $postalcode = $_.postalCode
    $telephonenumber = $_.mobilePhone
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $password
    $empid = $_.EmpId

    # try {
    #     $extensionProp = New-Object "System.Collections.Generic.Dictionary`2[System.String,System.String]"
    #     $extensionProp.Add('extension_1d76a2a42e094de0ba15735335b6371f_employeeNumber',$empid)
    #     $extensionProp.Add('extension_1d76a2a42e094de0ba15735335b6371f_employeeID','0'+$empid)
    #     $extensionProp.Add('employeeId','0'+$empid)
    # } catch {
    #     Write-Host "!!! $name has EmpId Field as null!" -ForegroundColor Red
    #     if ($nullid -ne "true") {
    #         Write-Output "`nTo allow execution with null Empid, use: './bulkcreateADAzure.ps1 -nullid true'"
    #         exit
    #     }
    #     $extensionProp = New-Object "System.Collections.Generic.Dictionary`2[System.String,System.String]"
    #     $extensionProp.Add('extension_1d76a2a42e094de0ba15735335b6371f_employeeNumber','0000')
    #     $extensionProp.Add('extension_1d76a2a42e094de0ba15735335b6371f_employeeID','0'+'0000')
    #     $extensionProp.Add('employeeId','0'+'0000')
    # }

    # $userinfo = Get-ADUser -Identity $samaccountname -ErrorAction SilentlyContinue 
    
    Write-Host "Creating user account for $samaccountname"
    try {
        New-AzureADUser `
        -GivenName $givenname `
        -Surname $surname `
        -DisplayName $name `
        -MailNickName $samaccountname `
        -UserPrincipalName $emailaddress `
        -PasswordProfile $PasswordProfile `
        -ExtensionProperty $extensionProp `
        -JobTitle $jobtitle `
        -Department $department `
        -Country $country `
        -City $city `
        -PostalCode $postalcode `
        -TelephoneNumber $telephonenumber `
        -AccountEnabled $true
    }
    catch {
        Write-Host $Error.Exception.Message
    }

    # Setting Manager

    try {
        $userObjId = Get-AzureADUser -ObjectId $emailaddress | Select-Object -ExpandProperty ObjectId
        $managerObjId = Get-AzureADUser -ObjectId $manager | Select-Object -ExpandProperty ObjectId
        Write-Host "Updating manager for $userPrincipalName to $NewManager"
        Set-AzureADUserManager -ObjectId $userObjId -RefObjectId $managerObjId
    }
    catch {
        Write-Host "!!! Could not update manager for $name" -ForegroundColor Red
        Write-Host $Error.Exception.Message
    }

    # Setting Empid
    
    if($empid){
        try {
            $userObjId = Get-AzureADUser -ObjectId $emailaddress | Select-Object -ExpandProperty ObjectId
            Write-Host "Updating employee ID for $userPrincipalName to $empid"
            Set-AzureADUserExtension -ObjectId $userObjId -ExtensionName employeeId -ExtensionValue $empid
        }
        catch {
            Write-Host "!!! Could not update employee ID for $name" -ForegroundColor Red
            Write-Host $Error.Exception.Message
        }
    }    
}