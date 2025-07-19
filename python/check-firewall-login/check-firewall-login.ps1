$filePath = "firewall-ip-list.txt"
$ips = Get-Content -Path $filePath

$nonworking = @()

foreach ($ip in $ips) {

    try {
        # Code that might throw an exception
        $myJson = python panxapi.py -h $ip -K "api_key" -Xjro "show system info" 
    } catch {
        # Code to handle the exception
        Write-Host "An error occurred for $ip : $_"
    }

    if ($null -ne $myJson) {
        $myJson = $myJson | Select-String -Pattern "op: success" -NotMatch
        $myJson = $myJson | ConvertFrom-Json
        Write-Host "Success for" $myJson.system.'ip-address' ": " $myJson.system.devicename
    }  else {
        Write-Host "An error occurred for $ip"
        $nonworking += $ip.ToString()
    }

    # Write-Host "Success for" $myJson.system.'ip-address' ": " $myJson.system.devicename
}

Write-Host "List of non-working IPs: " 
foreach ($ip in $nonworking){
    $ip
}