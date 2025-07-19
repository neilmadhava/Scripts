# Useful Info
# XML Parsing - https://docs.python.org/3/library/xml.etree.elementtree.html#finding-interesting-elements
# Palo Alto API - https://knowledgebase.paloaltonetworks.com/KCSArticleDetail?id=kA10g000000ClZLCA0
# How to run this file: python vpninfo.py <VPN CI>

# IMPORTS
import subprocess
import xml.etree.ElementTree as ET
import argparse
from time import sleep
from colorama import Fore, Back, Style


# Pretty Stuff - ARGPARSE
parser = argparse.ArgumentParser(
    prog='vpninfo',
    description='Get phase 2 tunnel details for a given VPN CI')
parser.add_argument('tunnel', nargs='+')
args = parser.parse_args()

# Get VPN flow status and save in a file - .\vpnflow.xml
# The subprocess cmd is calling a powershell script (gettunnelstatus.ps1) which is running a single command -  
# python panxapi.py -h 135.8.2.62 -K "API_KEY" -x -o "<show><vpn><flow/></vpn></show>" | Out-File -FilePath 'vpnflow.xml'
# To get API key for a specific user - check the KB article mentioned at the top of this script

print("Getting curent tunnel status. Please Wait...")
subprocess.run([r'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe', r'.\gettunnelstatus.ps1'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
# sleep(5)

# SET VARIABLES
tree = ET.parse('vpnflow.xml')
root = tree.getroot()
tunnels = args.tunnel

# GET info about specific tunnel
for tunnel in tunnels:
    print ("\n------------------", "\n", "TUNNEL: ", tunnel, "\n", "------------------")
    flag = 0
    for entry in root.iter('entry'):
        name = entry.find('name').text
        peerip = entry.find('peerip').text
        state = entry.find('state').text
        # Check for a tunnel with proxy-id configured (checking for existence of ":" in tunnel name)
        # if proxy-id configured tunnel, then do a partial match for "VPN_CI:" in the tunnel name
        # else do an exact match for given VPN_CI in tunnel name
        if(":" in name):
            search_tunnel = tunnel + ":"
            if(search_tunnel in name):
                if (state == "active"):
                    flag=1
                print(name, '\t', peerip, '\t', state)
        else:
            if(tunnel == name):
                if (state == "active"):
                    flag=1
                print(name, '\t', peerip, '\t', state)
        
    if (flag == 1):
        print ("\n" + Fore.GREEN + "Tunnel " + tunnel + " is UP!!!")
        print(Style.RESET_ALL)
    else:
        print ("\n" + Fore.RED + "Tunnel " + tunnel + " is DOWN!!!")
        print(Style.RESET_ALL)