# Get peer name

$peer = $args[0]

# Write-Host($peer)
python.exe panxapi.py -h 1.1.1.1 -K "api_key" -x -o "<show><routing><protocol><bgp><peer><peer-name>$peer</peer-name></peer></bgp></protocol></routing></show>" -r | Out-File -FilePath 'bgpstate.xml'