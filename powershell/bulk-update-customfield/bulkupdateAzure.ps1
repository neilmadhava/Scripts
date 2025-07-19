# employeeId is the custom field we can update using this script
Import-Csv "sample.csv" |  ForEach-Object{
    $EmployeeNumber = $_.EmpId
    $name = "'" + $_.DisplayName.Trim() + "'"
    Write-Host "Updating empid for $name - $EmployeeNumber"
    # Get-AzureADUser -Filter "startswith(displayname,$name)" | Set-AzureADUserExtension -ExtensionName employeeId -ExtensionValue $EmployeeNumber
}

Write-Host "Displaying results in few seconds. Please Wait..."
Start-Sleep 3

Import-Csv "sample.csv" | ForEach-Object{ 
    $name = "'" + $_.DisplayName.Trim() + "'"
    $user = Get-AzureADUser -Filter "startswith(displayname,$name)"
    $dispname = $user | Select-Object -ExpandProperty DisplayName
    $empid = ($user | Select-Object -ExpandProperty ExtensionProperty).employeeId
    Write-Host "$dispname - $empid"
}
