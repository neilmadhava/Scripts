# Importing modules
import boto3
import pandas as pd

profile = "sample_name"
regions = ["us-east-1", "us-west-2"]
instances_info = []

def describe_instance(profile, region, instance_info):
    session = boto3.Session(profile_name=profile, region_name=region)
    ec2 = session.client('ec2')
    try:    
        response = ec2.describe_instances()
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                public_ip = instance.get('PublicIpAddress','N/A')
                if public_ip != "N/A":    
                    instance_id = instance['InstanceId']
                    private_ip = instance.get('PrivateIpAddress', 'N/A')
                    state = instance['State']['Name']
                    for item in instance["Tags"]:
                        if item.get("Key") == "Name":
                            name = item.get("Value")
                            break
                    instances_info.append([instance_id, state, private_ip, public_ip, name])
    except Exception as e:
        print("The error raised is: ", e)
    return instance_info


for region in regions:
    describe_instance(profile, region, instances_info)

for instance in instances_info:
    print(*instance)

running_instances = [instance for instance in instances_info if "stopped" not in instance]
print("\nExporting running instance inforation to excel...")

df = pd.DataFrame(running_instances, columns = ["Instance ID", "State", "Private IP", "Public IP", "Name"])
df.to_excel("Sample.xlsx", index=False)