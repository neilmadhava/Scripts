# Useful Info
# XML Parsing - https://docs.python.org/3/library/xml.etree.elementtree.html#finding-interesting-elements
# Palo Alto API - https://knowledgebase.paloaltonetworks.com/KCSArticleDetail?id=kA10g000000ClZLCA0
# Example: 
#   python bgpinfo.py Azure_APCS_Staging

# IMPORTS
import subprocess
import xml.etree.ElementTree as ET
import argparse
from time import sleep
from colorama import Fore, Back, Style


# Pretty Stuff - ARGPARSE
parser = argparse.ArgumentParser(
    prog='bgpinfo',
    description='Get BGP peer status for a given peer name')
parser.add_argument('peer', nargs='+')
args = parser.parse_args()

# Get BGP state and save in file - .\bgpstate.xml

print("Getting peer status. Please Wait...")


# SET VARIABLES
peers = args.peer

# GET info about bgp peers 
for peer in peers:
    cmd = ["PowerShell", "-ExecutionPolicy", "Unrestricted", "-File", ".\\bgpstate.ps1", peer]
    subprocess.call(cmd)
    tree = ET.parse('bgpstate.xml')
    root = tree.getroot()
    print ("\n ------------------", "\n", "BGP PEER: ", peer, "\n", "------------------")
    status = root.find('status').text
    peer_address = root.find('peer-address').text
    duration = root.find('status-duration').text
       
    if (status == 'Established'):
        print ("\n" + Fore.GREEN + "Peer:  " + peer + " is UP!!!")
        print("Peer address: " + peer_address)
        print("Status: " + status)
        print("Status Duration: " + duration)
        print(Style.RESET_ALL)
    else:
        print ("\n" + Fore.RED + "Tunnel " + peer + " is DOWN!!!")
        print("Peer address: " + peer_address)
        print("Status: " + status)
        print("Status Duration: " + duration)
        print(Style.RESET_ALL)