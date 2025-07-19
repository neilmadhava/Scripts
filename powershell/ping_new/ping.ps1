Start-Transcript -Path .\log.txt
$filename = ".\ip-list.txt"
(Get-Content $filename) | ForEach-Object {
    Write-Host $_.split(":")[0],  "-", $_.split(":")[1],
    ([System.Net.NetworkInformation.Ping]::new().Send($_.split(":")[1])).Status
}
Stop-Transcript