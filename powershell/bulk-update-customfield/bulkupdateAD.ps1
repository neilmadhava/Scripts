# EmployeeID is a custom fiel in AD which we can update using this script 
Import-Csv "sample.csv" |  ForEach-Object{
    $EmployeeNumber = $_.EmpId
    $name = "'" + $_.DisplayName.Trim() + "*'"
    $dispname = $_.DisplayName.Trim()
    # Get-ADUser -Filter "Name -like $name" | Select-Object -ExpandProperty Name
    Write-Host "Updating empid for $dispname - $EmployeeNumber"
    Get-ADUser -Filter "Name -like $name" | Set-ADUser -EmployeeID $EmployeeNumber -EmployeeNumber $EmployeeNumber
}

Write-Host "Displaying results in few seconds. Please Wait..."
Start-Sleep 3

Import-Csv "sample.csv" | ForEach-Object{ 
    $name = "'" + $_.DisplayName.Trim() + "*'"
    Get-ADUser -Filter "Name -like $name" -Property * | Select-Object DisplayName,EmployeeNumber,EmployeeID
}
