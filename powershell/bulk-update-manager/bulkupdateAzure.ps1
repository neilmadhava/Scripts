Import-Csv "sample.csv" |  ForEach-Object{
    
    $Manager = $_.New_Manager + '*'
    $NewManager = Get-ADUser -Filter "DisplayName -like '$Manager'" -Property * | Select-Object -ExpandProperty userprincipalname
    $managerObjId = Get-AzureADUser -ObjectId $NewManager | Select-Object -ExpandProperty ObjectId
    
    $EmployeeNumber = $_.EmployeeNo
    $userPrincipalName = Get-ADUser -Filter "EmployeeNumber -eq $EmployeeNumber" -Property * | Select-Object -ExpandProperty UserPrincipalName
    $userObjId = Get-AzureADUser -ObjectId $userPrincipalName | Select-Object -ExpandProperty ObjectId
    Write-Output "Updating manager for $userPrincipalName to $NewManager"
    Set-AzureADUserManager -ObjectId $userObjId -RefObjectId $managerObjId
}


Write-Output "Final Output - "
Import-Csv "sample.csv" | ForEach-Object{ 
    $EmployeeNumber = $_.EmployeeNo
    $userPrincipalName = Get-ADUser -Filter "EmployeeNumber -eq $EmployeeNumber" -Property * | Select-Object -ExpandProperty UserPrincipalName
    $Manager = Get-AzureADUserManager -ObjectId $userPrincipalName | Select-Object -ExpandProperty DisplayName
    Write-Output "$userPrincipalName - $Manager"
}
