Start-Transcript -Path .\log.txt
(Get-Content .\ip-list.txt) | ForEach-Object {Write-Host $_, "-", ([System.Net.NetworkInformation.Ping]::new().Send($_)).Status}
Stop-Transcript