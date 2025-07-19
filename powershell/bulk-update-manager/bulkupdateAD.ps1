Import-Csv "sample.csv" |  ForEach-Object{
    
    $Manager = $_.New_Manager + '*'
    $NewManager = Get-ADUser -Filter "DisplayName -like '$Manager'"
    $EmployeeNumber = $_.EmployeeNo
    Write-Host "Updating manager for empid. $EmployeeNumber"
    Get-ADUser -Filter "EmployeeNumber -eq $EmployeeNumber" | Set-ADUser -Manager $NewManager
}


Import-Csv "sample.csv" | ForEach-Object{ 
    $EmployeeNumber = $_.EmployeeNo
    Get-ADUser -Filter "EmployeeNumber -eq $EmployeeNumber" -Property * | Select-Object DisplayName,Manager 
}
