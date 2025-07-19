# Use this scrip to search for a particular resource in AWS if you are managing 
# multiple accounts and want to search IP simultaneously in all accounts

# Importing modules
import boto3
import json
from ipaddress import ip_network

# Get input from user
search_ip = input("Enter IP to search for: ")
search_profile = input("Enter profile to search in [eg. all or sample_profile]: ")

# This function returns value to be used as "param" value in request
def pub_or_pvt(ip):
    if((ip_network(ip).subnet_of(ip_network('10.0.0.0/8')) == True) or \
        (ip_network(ip).subnet_of(ip_network('172.16.0.0/12')) == True) or \
        (ip_network(ip).subnet_of(ip_network('192.168.0.0/16')) == True)):
        return "network-interface.addresses.private-ip-address"
    return "ip-address"

# This function searches all EC2 instances with a specific ip address and returns response
def find_ip(ip_addr, profile, region, param):    
    session = boto3.Session(profile_name=profile, region_name=region)
    ec2 = session.client('ec2')
    try:    
        response = ec2.describe_instances(
            Filters=[
                {
                    'Name': param,
                    'Values': [
                        ip_addr,
                    ]
                },
            ]
        )
        return response
    except Exception as e:
        print("The error raised is: ", e)
        return '{"Reservations": []}' 

# Search for an EC2 instance in 2 aws regions
def find_ip_region(ip, profile, param):
    regions = ['us-east-1', 'us-west-2']
    for region in regions:
        response = find_ip(ip, profile, region, param)
        response_len = dict(response)['Reservations']    
        if len(response_len) != 0:
            response_dict = dict(response)['Reservations'][0]['Instances'][0]
            print('Instance ID: ', response_dict['InstanceId'])
            for tags in response_dict['Tags']:
                if (tags['Key'] == "Name" or tags['Key'] == "Description"):
                    print(tags['Key'], ":", tags['Value'])
            return "found"

# stores all profiles to search in
# this should match profiles in ~/.aws/credentials file
profiles = ['sample1', 'sample2', 'sample3']

# Main section of the program
param_val = pub_or_pvt(search_ip)

if search_profile == 'all':
    for profile in profiles:
        print("Searching in profile ", profile)
        found = find_ip_region(search_ip, profile, param_val)
        if found == "found":
            break
else:
    find_ip_region(search_ip, search_profile, param_val)
