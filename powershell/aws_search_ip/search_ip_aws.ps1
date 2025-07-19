$search_ip = Read-Host "Enter ip address"
$search_profile = Read-Host "Enter profile to search in [eg. abcd_efgh]"

$regions = @("us-east-1","us-west-2")
$param_bool = python -c "from ipaddress import ip_network; print(ip_network('$search_ip').subnet_of(ip_network('10.0.0.0/8')) or ip_network('$search_ip').subnet_of(ip_network('172.16.0.0/12')) or ip_network('$search_ip').subnet_of(ip_network('192.168.0.0/16')))"

if ($param_bool -eq $true){
    $param = "network-interface.addresses.private-ip-address"
} else {
    $param = "ip-address"
}

foreach($region in $regions) {
    $response = aws ec2 describe-instances --filters "Name=$param,Values=$search_ip" --query "Reservations[].Instances[]" --region $region --profile $search_profile
    if ($response.length -gt 2){
        $tags = ($response | ConvertFrom-Json).Tags | Where-Object { $_.Key -eq "Name" -or $_.Key -eq "Description" }
        Write-Host "FOUND!!" 
        Write-Output $tags
    }
}